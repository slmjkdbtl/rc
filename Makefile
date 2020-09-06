# wengwengweng

ifeq ($(XDG_CONFIG_HOME),)
CONFIG := $(HOME)/.config
else
CONFIG := $(XDG_CONFIG_HOME)
endif

.PHONY: conf
conf:

	mkdir -p $(CONFIG)

	$(foreach f, nvim fish alacritty mpv mutt kak, \
		echo "  - $(f) -> $(CONFIG)/$(f)"; \
		ln -sf $(realpath $(f)) $(CONFIG); \
	)

	$(foreach f, .yabairc .skhdrc .tmux.conf .procs.toml .tigrc .gitconfig .gitignore_global .eslintrc.yml, \
		echo "  - $(f) -> $(HOME)/$(f)"; \
		ln -sf $(realpath $(f)) $(HOME); \
	)

	tic $(realpath super.terminfo)

