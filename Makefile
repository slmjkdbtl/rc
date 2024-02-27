CONFIG = $(HOME)/.config
LOCAL_BIN = $(HOME)/.local/bin
TO_CONFIG = nvim mpv
TO_HOME = .vim .skhdrc .tmux.conf .gitconfig .wezterm.lua .zshrc .profile .inputrc .sqliterc
CONFIG_TARGETS = $(addprefix $(CONFIG)/, $(TO_CONFIG))
HOME_TARGETS = $(addprefix $(HOME)/, $(TO_HOME))
LOCAL_BIN_TARGETS = $(patsubst scripts/%, $(LOCAL_BIN)/%, $(wildcard scripts/*))
CMUS_TARGETS = $(patsubst cmus/%, $(CONFIG)/cmus/%, $(wildcard cmus/*))

.PHONY: install
install: $(CONFIG_TARGETS) $(HOME_TARGETS) $(LOCAL_BIN_TARGETS) $(CMUS_TARGETS)

.PHONY: uninstall
uninstall:
	rm $(CONFIG_TARGETS) $(HOME_TARGETS) $(LOCAL_BIN_TARGETS)

$(CONFIG)/%: %
	ln -sf $(realpath $<) $@

$(CONFIG)/cmus/%: cmus/%
	ln -sf $(realpath $<) $@

$(HOME)/%: %
	ln -sf $(realpath $<) $@

$(LOCAL_BIN)/%: scripts/%
	ln -sf $(realpath $<) $@

.PHONY: update
update: albums.txt Brewfile $(WORKFLOW_DEST)

albums.txt: Library.xml genAlbums.js
	bun genAlbums.js

Brewfile: FORCE
	brew bundle dump -f

.PHONY: FORCE
FORCE:
