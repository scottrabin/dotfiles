all: link vundle

link:
	if [ -e ~/.vimrc ]; then mv ~/.vimrc ~/.vimrc.bkp; fi
	ln -s ~/.vim/vim.config ~/.vimrc

bundle:
	git submodule init
	git submodule update
	
.PHONY: all link bundle
