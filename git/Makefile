path := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

install: $(HOME)/.gitconfig $(HOME)/bin/git-cmp

$(HOME)/.gitconfig: $(path)/.gitconfig
	cp $< $@
	git config --global init.templatedir $(path)/template
	git config --global core.excludesfile $(path)/.gitignore
ifeq ($(shell uname -s),Darwin)
	git config --global credential.helper osxkeychain
endif
	@read -p "Git user.name: " username; \
	git config --global user.name "$$username"
	@read -p "Git user.email: " useremail; \
	git config --global user.email "$$useremail"

$(HOME)/bin/git-cmp: $(path)/bin/git-cmp
	ln -sf $< $@
