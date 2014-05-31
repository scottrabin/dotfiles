all: link bundle

link:
	if [ -e ~/.vimrc ]; then mv ~/.vimrc ~/.vimrc.bkp; fi
	ln -s ~/.vim/.vimrc ~/.vimrc

bundle:
	git submodule init
	git submodule update
	
.PHONY: all link bundle
