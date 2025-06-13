CONFIG = $(HOME)/.config
LOCAL_BIN = $(HOME)/.local/bin
TO_CONFIG = nvim mpv wezterm yt-dlp
TO_HOME = .vim .skhdrc .tmux.conf .gitconfig .zshrc .profile .inputrc .sqliterc
CONFIG_TARGETS = $(addprefix $(CONFIG)/, $(TO_CONFIG))
HOME_TARGETS = $(addprefix $(HOME)/, $(TO_HOME))
LOCAL_BIN_TARGETS = $(patsubst scripts/%, $(LOCAL_BIN)/%, $(wildcard scripts/*))

.PHONY: install
install: $(CONFIG_TARGETS) $(HOME_TARGETS) $(LOCAL_BIN_TARGETS)

.PHONY: uninstall
uninstall:
	rm $(CONFIG_TARGETS) $(HOME_TARGETS) $(LOCAL_BIN_TARGETS)

$(CONFIG)/%: %
	ln -sf $(realpath $<) $@

$(HOME)/%: %
	ln -sf $(realpath $<) $@

$(LOCAL_BIN)/%: scripts/%
	ln -sf $(realpath $<) $@

.PHONY: update
update: Brewfile

Brewfile: FORCE
	brew bundle dump -f

.PHONY: FORCE
FORCE:
