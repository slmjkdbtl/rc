CONFIG = $(HOME)/.config
USERBIN = $(HOME)/.local/bin
TO_CONFIG = nvim mpv fish wezterm
TO_HOME = vim dshrc skhdrc tmux.conf gitconfig
CONFIG_TARGETS := $(patsubst %, $(CONFIG)/%, $(TO_CONFIG))
HOME_TARGETS := $(patsubst %, $(HOME)/.%, $(TO_HOME))
USERBIN_TARGETS := $(patsubst scripts/%, $(USERBIN)/%, $(wildcard scripts/*))

.PHONY: install
install: $(CONFIG_TARGETS) $(HOME_TARGETS) $(USERBIN_TARGETS)

.PHONY: uninstall
uninstall:
	rm $(CONFIG_TARGETS) $(HOME_TARGETS) $(USERBIN_TARGETS)

$(CONFIG)/%: %
	ln -sf $(realpath $<) $@

$(HOME)/.%: %
	ln -sf $(realpath $<) $@

$(USERBIN)/%: scripts/%
	ln -sf $(realpath $<) $@

.PHONY: update
update: albums.txt Brewfile

albums.txt: Library.xml genAlbums.js
	bun genAlbums.js

.PHONY: Brewfile
Brewfile:
	brew bundle dump -f
