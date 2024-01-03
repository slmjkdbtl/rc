CONFIG = $(HOME)/.config
USERBIN = $(HOME)/.local/bin
TO_CONFIG = nvim mpv fish
TO_HOME = vim skhdrc tmux.conf gitconfig wezterm.lua
CONFIG_TARGETS = $(addprefix $(CONFIG)/, $(TO_CONFIG))
HOME_TARGETS = $(addprefix $(HOME)/., $(TO_HOME))
USERBIN_TARGETS = $(patsubst scripts/%, $(USERBIN)/%, $(wildcard scripts/*))

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
update: albums.txt Brewfile $(WORKFLOW_DEST)

albums.txt: Library.xml genAlbums.js
	bun genAlbums.js

Brewfile: FORCE
	brew bundle dump -f

.PHONY: FORCE
FORCE:
