all: link vundle

link:
	if [ -e ~/.vimrc ]; then mv ~/.vimrc ~/.vimrc.bkp; fi
	ln -s ~/.vim/vim.config ~/.vimrc

vundle:
	git submodule init
	git submodule update
	vim +BundleClean +qall
	vim +BundleInstall +qall

clean:
	rm -rf ~/.vim/bundle/*
	
.PHONY: all link vundle command-t clean
