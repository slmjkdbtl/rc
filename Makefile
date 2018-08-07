# wengwengweng

ifeq ($(XDG_CONFIG_HOME),)
	CONFIG=$(HOME)/.config
else
	CONFIG=$(XDG_CONFIG_HOME)
endif

.PHONY: conf
conf:

	echo "+ linking"
	echo "  - nvim -> $(CONFIG)"
	ln -sf $(realpath nvim) $(CONFIG)
	echo "  - fish -> $(CONFIG)"
	ln -sf $(realpath fish) $(CONFIG)
	echo "  - mpv -> $(CONFIG)"
	ln -sf $(realpath mpv) $(CONFIG)
	echo "  - scripts -> $(CONFIG)"
	ln -sf $(realpath scripts) $(CONFIG)
	echo "  - .skhdrc -> $(HOME)"
	ln -sf $(realpath .skhdrc) $(HOME)
	echo "  - .tmux.conf -> $(HOME)"
	ln -sf $(realpath .tmux.conf) $(HOME)
	echo "  - .tigrc-> $(HOME)"
	ln -sf $(realpath .tigrc) $(HOME)
	echo "+ ticcing terminfos"
	tic $(realpath super.terminfo)
	echo "+ copying nvim to ~/.vim"
	rm -rf $(HOME)/.vim
	cp -r $(realpath nvim) $(HOME)/.vim
	mv $(HOME)/.vim/init.vim $(HOME)/.vim/vimrc
	mv $(HOME)/.vim/misc $(HOME)/.vim/autoload

