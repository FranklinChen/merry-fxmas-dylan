# merry-fxmas-dylan

[![Build Status](https://travis-ci.org/FranklinChen/merry-fxmas-dylan.png)](https://travis-ci.org/FranklinChen/merry-fxmas-dylan)

(I turned off Travis because it couldn't run the Dylan compiler, maybe because it is compiled for i386?)

Say "Merry Christmas" 25 times, using a syntactic macro in Dylan.

## Usage

First, install [Open Dylan](http://opendylan.org/).

Edit `Makefile` to point to where you installed the Dylan compiler `dylan-compiler`.

To compile (this may take a long time at first because of pulling in all the libraries into the local `_build` directory):

```
$ make
```

To see the output:

```
$ make run
```
