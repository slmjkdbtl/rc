CONFIG = $(HOME)/.config
LOCAL_BIN = $(HOME)/.local/bin
CMUS = $(CONFIG)/cmus
TO_CONFIG = nvim mpv wezterm yt-dlp mpd
TO_HOME = .vim .skhdrc .tmux.conf .gitconfig .zshrc .profile .inputrc .sqliterc
CONFIG_TARGETS = $(addprefix $(CONFIG)/, $(TO_CONFIG))
HOME_TARGETS = $(addprefix $(HOME)/, $(TO_HOME))
LOCAL_BIN_TARGETS = $(patsubst scripts/%, $(LOCAL_BIN)/%, $(wildcard scripts/*))
CMUS_TARGETS = $(patsubst cmus/%, $(CMUS)/%, $(wildcard cmus/*))

.PHONY: install
install: $(CONFIG_TARGETS) $(HOME_TARGETS) $(LOCAL_BIN_TARGETS) $(CMUS_TARGETS)

.PHONY: uninstall
uninstall:
	rm $(CONFIG_TARGETS) $(HOME_TARGETS) $(LOCAL_BIN_TARGETS)

$(CONFIG)/%: %
	ln -sf $(realpath $<) $@

$(HOME)/%: %
	ln -sf $(realpath $<) $@

$(LOCAL_BIN)/%: scripts/%
	ln -sf $(realpath $<) $@

$(CMUS)/%: cmus/%
	ln -sf $(realpath $<) $@

$(CONFIG_TARGETS): | $(CONFIG)
$(LOCAL_BIN_TARGETS): | $(LOCAL_BIN)
$(CMUS_TARGETS): | $(CMUS)

$(CONFIG):
	mkdir -p $@

$(LOCAL_BIN):
	mkdir -p $@

$(CMUS):
	mkdir -p $@

.PHONY: update
update: Brewfile

Brewfile: FORCE
	brew bundle dump -f

.PHONY: FORCE
FORCE:
