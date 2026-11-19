# AGENTS.md

Guidance for agents and contributors working in this repository.

## Intent

The point of this project is the recursive syntactic macro in
`src/lib/merry-fxmas.dylan`, which expands a literal token list into that many
straight-line calls at compile time. Replacing the expansion with a run-time
loop, or sidelining the macro, removes the reason the project exists.

The README holds the reasoning behind the macro, the module split, and the
types. Read it before changing any of them.

## Build traps

Verified against Open Dylan 2026.2 and deft v0.13.0.

- **`deft build` exits 0 when the build fails**, emitting no binaries. Its exit
  status is not a gate; `make build` and CI assert the binaries exist instead.
  `deft test` is unaffected and exits 1 correctly.
- **The log prints `Build of 'X' completed` immediately before `failed with
  exit status 3`.** Grepping for "completed" reports success on a broken build.
- **`Serious warning` is a build failure**, not something to triage later.
- **A source file missing from its `.lid` `Files:` list is silently ignored**,
  undefined references and all. Paths there are relative to the `.lid`.
- **Every `.dylan` file needs a `Module:` header.** Omitting it surfaces as
  `Internal error: Link failed: File dylanmakefile.mkf does not exist`.
- **Build with `--all`.** Libraries are version-checked at startup, so an
  executable left unrelinked against a rebuilt core library dies at run time.

## Commands

`make`, `make run`, `make test`, `make clean` cover normal work. Test-runner
flags the README does not mention:

```
./_build/bin/merry-fxmas-test-suite --list tests
./_build/bin/merry-fxmas-test-suite --run <test-name>
./_build/bin/merry-fxmas-test-suite --progress all --report full
```

To add a dependency: put it in `dylan-package.json`, run `deft update`, then
add a `use` clause to the `define library`. It must exist in `pacman-catalog`.

## Rules

- Never name stdout in the core library. It writes to a `<stream>` it is
  handed, and that seam is what makes it testable.
- Never thread `?stream` into the macro's auxiliary rules. It is out of scope
  there; they use the bare `greeting-stream` the main rule binds.
- Never add a greeting-count constant to the library. The token list in
  `write-greetings` is the single source of truth, and the test suite owns its
  own expected count.
- Never export the implementation module. The library exports only
  `merry-fxmas`, so its `create` list is exactly the public API.
- Never test an invariant a type already enforces. `<countdown>` is
  `limited(<integer>, min: 1)`, so nothing tests that position 0 is rejected.
- Keep `expected-countdown` free of `format`. Sharing the implementation's
  formatting call would let a bug cancel out on both sides of the assertion.
- Never commit `_build/`, `_packages/`, `registry/`, `_test/`. All generated.

## CI

`.github/workflows/build-and-test.yml` runs two jobs: build, run, and test on
Linux and macOS, and `actionlint` (which also shellchecks the `run:` blocks).
Current pins, checked 2026-11-19: `actions/checkout` on floating `v7`,
`dylan-lang/install-opendylan` pinned to `v3.4.0` with the compiler itself
pinned to `v2026.2.0`, and `actionlint` installed from its release tarball
with a sha256 check before it runs. Re-check the currently published tags with
`gh api` before bumping any of them; never copy these forward on faith.
`make ci` reproduces the local part of the pipeline.
