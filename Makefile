# wengwengweng

ifeq ($(XDG_CONFIG_HOME),)
	CONFIG := $(HOME)/.config
else
	CONFIG := $(XDG_CONFIG_HOME)
endif

.PHONY: conf
conf:

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

.PHONY: setup
setup:

	sudo -v
	xcode-select --install
	echo "+ installing homebrew"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	echo "+ installing fish"
	brew install fish
	echo "+ installing neovim"
	brew install neovim
	echo "+ changing default shell to fish"
	sudo chsh -s /usr/local/bin/fish
	make

