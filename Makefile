# wengwengweng

NVIM = $(HOME)/.config
FISH = $(HOME)/.config
MPV = $(HOME)/.config
SCRIPTS = $(HOME)/.config
TMUX = $(HOME)/
SKHDRC = $(HOME)/

.PHONY: link
link:

	echo "+ linking"
	echo "  - nvim -> $(NVIM)"
	ln -sf $(realpath nvim) $(NVIM)
	echo "  - fish -> $(FISH)"
	ln -sf $(realpath fish) $(FISH)
	echo "  - mpv -> $(MPV)"
	ln -sf $(realpath mpv) $(MPV)
	echo "  - scripts -> $(SCRIPTS)"
	ln -sf $(realpath scripts) $(SCRIPTS)
	echo "  - .skhdrc -> $(SKHDRC)"
	ln -sf $(realpath .skhdrc) $(SKHDRC)
	echo "  - .tmux.conf -> $(TMUX)"
	ln -sf $(realpath .tmux.conf) $(TMUX)
	echo "  - ticcing terminfos"
	tic $(realpath terminfos/super.terminfo)

.PHONY: vimrc
vimrc:

	echo "+ copying to ~/.vim"
	rm -rf $(HOME)/.vim
	cp -r $(realpath nvim) $(HOME)/.vim
	mv $(HOME)/.vim/init.vim $(HOME)/.vim/vimrc
	mv $(HOME)/.vim/misc $(HOME)/.vim/autoload
