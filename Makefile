# wengwengweng

ifeq ($(XDG_CONFIG_HOME),)
	CONFIG := $(HOME)/.config
else
	CONFIG := $(XDG_CONFIG_HOME)
endif

.PHONY: install
install:

	echo "+ linking"

	mkdir -p $(CONFIG)

	$(foreach f, nvim fish alacritty mpv, \
		echo "  - $(f) -> $(CONFIG)/$(f)"; \
		ln -sf $(realpath $(f)) $(CONFIG); \
	)

	$(foreach f, .yabairc .skhdrc .tmux.conf .tigrc .mpdconf, \
		echo "  - $(f) -> $(HOME)/$(f)"; \
		ln -sf $(realpath $(f)) $(HOME); \
	)

	echo "+ ticcing terminfos"
	tic $(realpath super.terminfo)

.PHONY: casks
casks: casks.txt

	echo "+ installing casks"

	while read l; do \
		brew cask install $$l; \
	done < casks.txt

