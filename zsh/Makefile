ZSH_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

$(HOME)/.zshrc: FORCE
	rm -f $@
	echo 'export ZSH="${ZSH}"' >> $@
	echo 'ZSH_CUSTOM=$(ZSH_DIR)' >> $@
	echo 'source $$ZSH/oh-my-zsh.sh' >> $@

FORCE:
