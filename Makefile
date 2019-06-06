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

	$(foreach f, nvim fish alacritty mpv mutt, \
		echo "  - $(f) -> $(CONFIG)/$(f)"; \
		ln -sf $(realpath $(f)) $(CONFIG); \
	)

	$(foreach f, .yabairc .skhdrc .tmux.conf .procs.toml .tigrc .mbsyncrc .mpdconf, \
		echo "  - $(f) -> $(HOME)/$(f)"; \
		ln -sf $(realpath $(f)) $(HOME); \
	)

	echo "+ ticcing terminfos"
	tic $(realpath super.terminfo)

