path    := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DOTDIR  := $(HOME)/.claude

.PHONY: all
all: $(DOTDIR)/CLAUDE.md $(DOTDIR)/settings.json

$(DOTDIR):
	mkdir -p $@

$(DOTDIR)/CLAUDE.md: $(path)/CLAUDE.md | $(DOTDIR)
	ln -sf $< $@

$(DOTDIR)/settings.json: $(path)/settings.json | $(DOTDIR)
	ln -sf $< $@
