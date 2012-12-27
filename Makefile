# Use Open Dylan http://opendylan.org/
DYLAN_COMPILER = dylan-compiler

RESULT = ./_build/bin/merry-fxmas

all:	$(RESULT)

run:	$(RESULT)
	$(RESULT)

clean:
	-rm -rf _build

$(RESULT):	merry-fxmas.dylan merry-fxmas.lid
	$(DYLAN_COMPILER) -build merry-fxmas.lid

.PHONY:	all run clean
