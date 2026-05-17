path := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DOTDIR := $(HOME)/.codex

.PHONY: all
all: $(DOTDIR)/AGENTS.md $(DOTDIR)/config.toml

$(DOTDIR):
	mkdir -p $@

$(DOTDIR)/AGENTS.md: $(path)/AGENTS.md | $(DOTDIR)
	ln -sf $< $@

$(DOTDIR)/config.toml: $(path)/config.base.toml | $(DOTDIR)
	cp -n $< $@
