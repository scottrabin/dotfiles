path    := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
DOTDIR  := $(HOME)/.claude

.PHONY: all
all: $(DOTDIR)/CLAUDE.md $(DOTDIR)/read-once $(DOTDIR)/settings.json $(DOTDIR)/skills/reflect $(DOTDIR)/statusline-command.sh

$(DOTDIR):
	mkdir -p $@

$(DOTDIR)/skills: | $(DOTDIR)
	mkdir -p $@

$(DOTDIR)/CLAUDE.md: $(path)/CLAUDE.md | $(DOTDIR)
	ln -sf $< $@

$(DOTDIR)/settings.json: $(path)/settings.json | $(DOTDIR)
	ln -sf $< $@

$(DOTDIR)/skills/reflect: $(path)/skills/reflect | $(DOTDIR)/skills
	ln -sfn $< $@

$(DOTDIR)/statusline-command.sh: $(path)/statusline-command.sh | $(DOTDIR)
	ln -sf $< $@
	chmod +x $@

$(DOTDIR)/read-once:
	curl -fsSL https://raw.githubusercontent.com/Bande-a-Bonnot/Boucle-framework/main/tools/read-once/install.sh | bash
