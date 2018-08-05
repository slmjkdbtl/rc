# wengwengweng

NVIM = ~/.config
FISH = ~/.config
MPV = ~/.config
SCRIPTS = ~/.config
TMUX = ~/
SKHDRC = ~/

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
