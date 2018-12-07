# OCaml Demo

This is an exmaple OCaml project using Nix to setup a development environment.

This uses Dune as its builder and the OCaml Package Manager. Dune replaces `ocamlbuild` and is more sophisticated builder. The OCaml Package Manager is not used for bringing in dependencies, only as a way to create the `*.opam` file and interaction with the Opam service.

The Nix derivation in `default.nix` uses the `ocamlPackages.buildDunePackage` function. This function is designed for building OCaml libraries. If you are building an application using OCaml, then you need to use `stdenv.mkDerivation` instead. However if you do so, you need to instead use `name` instead of `pname` and use `buildInputs = with ocamlPackages; [ ocaml dune findlib ]` to bring in the OCaml compilation pipeline. You also need to replicate the `buildPhase`, `checkPhase` and `installPhase` that is in the `buildDunePackage` function. See https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/ocaml/dune.nix for more information.

## Installation

If on Nix, you can install just by using:

```sh
nix-env -f ./default.nix -i
```

If you are not, then use `make`:

```sh
make
make install
```

## Developing

Run `nix-shell`, and once you're inside, you can use:

```sh
make
make clean
utop
dune build -p ocaml-demo
dune runtest -p ocaml-demo
```

The `Makefile` is conventionally used to abstract the OCaml builder commands, in this case that's `dune`. Use `make; make install PREFIX=/tmp;` to build the OCaml project into the `./_build` directory and subsequently install it in the relevant prefix.

Adding a new package can be done by inserting them into the `buildInputs` attribute of `default.nix`. You'll notice that `opam` and `utop` are in the `shell.nix` because they are only needed during development.

Inside `./bin` and `./src`, there are `dune` files. These files provide the metadata for how to compile the OCaml code. Code inside `./bin` will be compiled into executables. While `./src` will become libraries.

Use `utop` as an OCaml REPL:

```sh
dune utop src
```

This will load all the OCaml modules inside `src` into the `utop` REPL.

Once you are finished developing, you can build the package using:

```sh
nix-build
```

Using `dune` inside the `nix-shell` allows more granular control over compilation outputs.

These are all possible:

```sh
dune build bin/hello.exe
dune build bin/hello.exe.o
dune build bin/hello.bc
dune build bin/hello.bc.o
dune build bin/hello.bc.so
dune build bin/hello.so
dune build bin/hello.bc.js
```

It depends on the `modes` property inside the `./bin/dune` file.

```
(modes
  (native exe)
  (byte exe)
  (native shared_object)
  (byte shared_object)
  (native object)
  (byte object))
```

OCaml has a byte code compiler and native code compiler. In most cases you will prefer to use the native code compiler.

All executables in dune are produced as `.exe` extension regardless of which platform you're on. However afterwards the executables can be renamed to the appropriate extension on the target platform.

You can then run also execute specific executables:

```sh
dune exec bin/hello.exe
```

To run tests, just use:

```sh
dune runtests -p ocaml-demo
```

To publish an Opam package:

```sh
git tag 0.0.1
git push 0.0.1
opam publish
```

Note that the way Nix constructs the necessary compilation environment is through a setup hook in the `ocamlPackages.findlib` dependency. This setup hook creates the `OCAMLPATH` envrionment variable which points to every OCaml dependency.

## Other Documentation

* https://dune.readthedocs.io/en/latest
* https://medium.com/@bobbypriambodo/starting-an-ocaml-app-project-using-dune-d4f74e291de8

---

OCaml files are compiled into "modules". The files are always lowercased, but the module names are StudylyCaps.

The modules that are in a directory with a `dune` file are given a "library name". This name itself becomes another module. Other OCaml programs refer to the library by its public name, and can use it like a module using `open Library`. In that case any modules inside that library is also capable of being used.

However if the "library name" conflicts with a module name, that module becomes the library. Think of that module as the index of that library. It's sort of like the `__init__.py` file in Python modules.

Right now inside the `./src` directory, we have `demo.ml`. This acts as the index module of the `demo` library specified in `./src/dune`. Had there been no `demo.ml`, then the `demo` library is just a module containing the `Math` module derived from the `./src/math.ml`.

The directory name does not matter.
