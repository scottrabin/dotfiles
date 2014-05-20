path := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

$(HOME)/.gitconfig:
	cp $(path)/.gitconfig $(HOME)/.gitconfig
	git config --global init.templatedir $(path)/template
	git config --global core.excludesfile $(path)/.gitignore
	@read -p "Git user.name: " username; \
	git config --global user.name "$$username"
	@read -p "Git user.email: " useremail; \
	git config --global user.email "$$useremail"
