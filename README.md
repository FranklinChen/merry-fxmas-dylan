# merry-fxmas

Say "Merry Christmas" 25 times, using a syntactic macro in Dylan.

## Usage

First, install [Open Dylan](http://opendylan.org/).

Edit `Makefile` to point to where you installed the Dylan compiler; I have it installed in the recommended directory, `/opt/opendylan-2013.2`, and have my `PATH` set to pick up `/opt/opendylan-2013.2/bin` so that `dylan-compiler` is in my `PATH`.

To compile (this may take a long time at first because of pulling in all the libraries into the local `_build` directory):

```
$ make
```

To see the output:

```
$ make run
```
