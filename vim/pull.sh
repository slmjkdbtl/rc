#!/bin/sh

pull() {
	dir=$(pwd)
	if [ -d ext/$1 ]; then
		cd ext/$1 && git pull
	else
		mkdir -p ext
		cd ext && git clone $2
	fi
	cd $dir
}

pull ale https://github.com/dense-analysis/ale
pull ctrlp.vim https://github.com/ctrlpvim/ctrlp.vim
pull vim-signify https://github.com/mhinz/vim-signify
