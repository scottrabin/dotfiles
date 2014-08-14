GOROOT = $(shell go env GOROOT)
DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

all: bundle $(HOME)/.vim $(HOME)/.vimrc

$(HOME)/.vim: $(DIR)
	if [ -e $@ -a ! -h $@ ]; then mv $@ $@.bkp; fi
	ln -s $< $@

$(HOME)/.vimrc: $(DIR)/.vimrc
	if [ -e $@ -a ! -h $@ ]; then mv $@ $@.bkp; fi
	ln -s $< $@

bundle: bundle/go
	git submodule update --init --recursive

ifneq ($(strip $(GOROOT)),)
bundle/go: $(GOROOT)/misc/vim
	ln -s $(GOROOT)/misc/vim $(DIR)/bundle/go
else
bundle/go:
	$(info `go` is not installed; skipping)
endif

.PHONY: all bundle
