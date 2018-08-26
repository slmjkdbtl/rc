# wengwengweng

ifeq ($(XDG_CONFIG_HOME),)
	CONFIG := $(HOME)/.config
else
	CONFIG := $(XDG_CONFIG_HOME)
endif

.PHONY: conf
conf:

	echo "+ linking"

	$(foreach f, nvim fish mpv hammerspoon scripts, \
		echo "  - $(f) -> $(CONFIG)/$(f)"; \
		ln -sf $(realpath $(f)) $(CONFIG); \
	)

	$(foreach f, .skhdrc .tmux.conf .tigrc, \
		echo "  - $(f) -> $(HOME)/$(f)"; \
		ln -sf $(realpath $(f)) $(HOME); \
	)

	echo "+ ticcing terminfos"
	tic $(realpath super.terminfo)

