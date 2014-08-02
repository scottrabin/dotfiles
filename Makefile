all: git vim

git:
	make -C git

vim:
	make -C vim

.PHONY: git vim
