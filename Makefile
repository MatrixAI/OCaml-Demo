INSTALL_ARGS := $(if $(PREFIX),--prefix $(PREFIX),)

.DEFAULT_GOAL := default

default:
	dune build @install

install:
	dune install $(INSTALL_ARGS)

uninstall:
	dune uninstall $(INSTALL_ARGS)

reinstall: uninstall install

clean:
	dune clean

.PHONY: default install uninstall reinstall clean
