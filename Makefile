CONFIG = $(HOME)/.config
USERBIN = $(HOME)/.local/bin
TO_CONFIG = nvim mpv fish
TO_HOME = vim skhdrc tmux.conf gitconfig wezterm.lua
CONFIG_TARGETS = $(addprefix $(CONFIG)/, $(TO_CONFIG))
HOME_TARGETS = $(addprefix $(HOME)/., $(TO_HOME))
USERBIN_TARGETS = $(patsubst scripts/%, $(USERBIN)/%, $(wildcard scripts/*))

WORKFLOW_SRC_DIR = $(HOME)/Library/Services
WORKFLOW_DEST_DIR = workflows
WORKFLOWS = Compress Terminal
WORKFLOW_DEST = $(patsubst %, $(WORKFLOW_DEST_DIR)/%.workflow, $(WORKFLOWS))

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

$(WORKFLOW_DEST_DIR)/%: $(WORKFLOW_SRC_DIR)/%
	rm -rf $@
	cp -R $< $@

.PHONY: FORCE
FORCE:
