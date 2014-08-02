GOROOT = $(shell go env GOROOT)
DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

all: link bundle

link:
ifneq ($(shell readlink $(HOME)/.vimrc),$(DIR)/.vimrc)
	if [ -e ~/.vimrc ]; then mv ~/.vimrc ~/.vimrc.bkp; fi
	ln -s ~/.vim/.vimrc ~/.vimrc
endif

ifneq ($(strip $(GOROOT)),)
bundle/go: $(GOROOT)/misc/vim
	ln -s $(GOROOT)/misc/vim $(DIR)/bundle/go
else
bundle/go:
	$(info `go` is not installed; skipping)
endif

bundle: bundle/go
	git submodule update --init --recursive

.PHONY: all link bundle
