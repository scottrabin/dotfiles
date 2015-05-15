DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

all: bundle $(HOME)/.vim $(HOME)/.vimrc

$(HOME)/.vim: $(DIR)
	if [ -e $@ -a ! -h $@ ]; then mv $@ $@.bkp; fi
	ln -s $< $@

$(HOME)/.vimrc: $(DIR)/.vimrc
	if [ -e $@ -a ! -h $@ ]; then mv $@ $@.bkp; fi
	ln -s $< $@

bundle:
	git submodule update --init --recursive

.PHONY: all bundle
