# Supplemental
This folder contains supplemental knowledge about Ocaml you should have.

## Compiling and Running OCaml
This exercise introduces you to use of the OCaml compiler `ocamlc`. Calling the OCaml compiler directly is often tedious, but we present it here once so you can see what's going on under the hood. In the rest of this course, all projects will be built with Dune. Dune is a build system that automates calling the OCaml compiler for you, and generally you should prefer it to calling the compiler directly. Setting up a minimal Dune project takes very little effort, and thus we recommend using it whenever you want to compile OCaml!

### ocamlc
`ocamlc` is the basic OCaml compiler.
Run it as `ocamlc <file-0> ... <file-n>` with all the files that belong to a program to compile it into an executable named a.out.

For example create a file `helloworld.ml` with the content:

```ocaml
let _ = print_endline "Hello World!"
```

Then compile and run it:

```bash
ocamlc helloworld.ml
./a.out
```

This process also creates `.cmi` and `.cmo` files for each `.ml` file. They are binary representations of the public interface and implementation of a source file. They can be used instead of the source code when including libraries.

Check the [documentation](https://ocaml.org/manual/comp.html) for a list of all command line options and more advanced build steps.

### dune
Since listing every file required for compiling the program every time will get tedious fast, `dune` is able to find all files involved in a program by following some conventions.

To use dune, first you need to create a file named `dune-project` to tell dune about your project. Although this file can contain many options, all we need is to give it the contents:

```bash
(lang dune 2.0)
```
Next, a file named `dune` tells dune where it should start searching for program parts and also configures various options. Give it the content

```bash
(executable
 (name helloworld))
```

to tell dune to create a stand-alone program and to start looking in `helloworld.ml`.

You can tell dune to build you program by running `dune build .` (`.` is the path to the folder of the `dune` file to build).
You will note that dune only created a file `dune-project` that can be used to organize projects with multiple `dune` files and a directory `_build` that contains all the templorary files from building, but no actual executable to run your program.

How do you run your program with dune? Add the flag `(promote)` to your `dune` file to copy the finished executable to the source directory.

```bash
(executable
 (name helloworld)
 (promote))
```

and then build again. You will now find a file helloworld.exe that you can use to run your program (dune gives the program the file extension .exe even on platforms other than Windows).

Check the [documentation](https://dune.readthedocs.io/en/stable/dune-files.html#dune) for a list of all options you can use in a `dune` file.

### utop
Note that since your tutorial and homework assignments are libraries instead of executables they cannot be run directly and instead they just provide a list of functions that can be used by other programs.
One such program is `utop`: an REPL (Read Eval Print Loop) that can interactivly compile and run any OCaml code.

Go to a new empty directory and create a file `greeter.ml` with content

```ocaml
let greet name = "Hello " ^ name ^ "!"
```

and a file `dune` with content

```bash
(library
 (name greeter))
```

then run `dune utop .` to start a new utop session with your code loaded.

Here you can then enter any code and for example call your library with

```ocaml
Greeter.greet "Alice";;
```

If you change the source of your library you need to reload it by exiting utop by pressing `Ctrl+D` and restarting utop.

### Example Solution
```bash
# ocamlc

mkdir -p /tmp/dunetest && cd /tmp/dunetest
echo 'let _ = print_endline "Hello World!"' > helloworld.ml
ocamlc helloworld.ml
ls
./a.out
rm *.cmi *.cmo a.out

# dune

echo '(lang dune 2.0)' > dune-project
echo '(executable (name helloworld))' > dune
dune build .
ls
echo '(executable (name helloworld) (promote))' > dune
dune build .
ls
./helloworld.exe


# utop

rm -rf ./*
echo 'let greet name = "Hello " ^ name ^ "!"' > greeter.ml
echo '(library (name greeter))' > dune
dune utop .
# Greeter.greet "Alice";;
```
