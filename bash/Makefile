DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

all: $(HOME)/.bash_profile

$(HOME)/.bash_profile: $(DIR)/.bash_profile
	if [ -e $@ -a ! -h $@ ]; then mv $@ $@.bkp; fi
	ln -sf $< $@
