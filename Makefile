all: link vundle command-t

link:
	if [ -e ~/.vimrc ]; then mv ~/.vimrc ~/.vimrc.bkp; fi
	ln -s ~/.vim/vim.config ~/.vimrc

vundle:
	git submodule init
	git submodule update
	vim +BundleInstall +qall

command-t:
	cd ~/.vim/bundle/Command-T; bundle install; rake make

clean:
	rm -rf ~/.vim/bundle/*
	
.PHONY: all link vundle command-t clean
