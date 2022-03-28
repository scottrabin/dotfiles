ZSH_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

all: oh_my_zsh $(HOME)/.zshrc

$(HOME)/.zprofile: ./.zprofile
	cp $< $@

$(HOME)/.zshrc: ./.zshrc
	cp $< $@
	echo 'ZSH_CUSTOM=$(ZSH_DIR)' >> $@
	echo 'source $$ZSH/oh-my-zsh.sh' >> $@

oh_my_zsh:
	@if [ -d "$(HOME)/.oh_my_zsh" ]; then\
		sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";\
	fi

.PHONY: all oh_my_zsh
