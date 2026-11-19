# merry-fxmas: say "Merry Christmas" 25 times, using a syntactic macro.
#
# Every target delegates to deft, the Open Dylan workspace tool, so that a
# human at a shell and this Makefile drive the build the same way. CI calls
# deft directly rather than going through make, so that each step reports as
# its own named check.
#
# Requires Open Dylan: https://opendylan.org/

.PHONY: all update build run test clean ci

all: build

# Installs dependencies into _packages/ and regenerates registry/, which is
# why neither is checked in. Cheap and idempotent on a warm workspace.
update:
	deft update

# `deft build` exits 0 even when the compiler fails and emits no binaries
# (verified against deft v0.13.0), so its exit status is not a gate. Assert
# the artifacts it was supposed to produce actually exist.
build: update
	deft build --all
	@for binary in merry-fxmas-app merry-fxmas-test-suite; do \
		test -x "_build/bin/$$binary" || { \
			echo "build failed: _build/bin/$$binary was not produced" >&2; \
			exit 1; \
		}; \
	done

run: build
	./_build/bin/merry-fxmas-app

# Depends on build rather than re-running update itself: changing the core
# library without relinking the executables produces a library-incompatibility
# error at startup, so always rebuild everything together.
test: build
	deft test

# Remove everything generated so the next build starts from a clean checkout.
clean:
	rm -rf _build _packages _test registry

# Local parity with CI: build, execute the binary the way CI does, run the
# test suite, and lint the workflow. Requires actionlint on the PATH (brew
# install actionlint); it is a hard requirement, never an optional step,
# because a gate that can skip itself is not a gate.
ci: build
	@./_build/bin/merry-fxmas-app > .ci-greetings.tmp; \
	if ! head -n 1 < .ci-greetings.tmp | grep -qx 'Merry Christmas Bill 25!'; then \
		echo 'unexpected first line from merry-fxmas-app' >&2; \
		rm -f .ci-greetings.tmp; exit 1; \
	fi; \
	if ! tail -n 1 < .ci-greetings.tmp | grep -qx 'Merry Christmas Bill 1!'; then \
		echo 'unexpected last line from merry-fxmas-app' >&2; \
		rm -f .ci-greetings.tmp; exit 1; \
	fi; \
	rm -f .ci-greetings.tmp
	deft test
	actionlint .github/workflows/build-and-test.yml
