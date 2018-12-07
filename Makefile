.DEFAULT_GOAL := main

%.native:
	ocamlbuild -use-ocamlfind -I src $@

clean:
	ocamlbuild -clean

main: main.native

.PHONY: main clean
