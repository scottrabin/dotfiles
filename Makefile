all: git vim zsh bash ripgrep claude codex

git:
	make -C git

zsh:
	make -C zsh

bash:
	make -C bash

ripgrep:
	@rg --version >/dev/null 2>&1 || brew install ripgrep

claude:
	make -C claude

codex:
	make -C codex

.PHONY: git vim zsh bash ripgrep claude codex
