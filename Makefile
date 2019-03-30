all: git vim zsh bash

git:
	make -C git

vim:
	make -C vim

zsh:
	make -C zsh

bash:
	make -C bash

.PHONY: git vim zsh bash
