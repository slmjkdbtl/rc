# wengwengweng

ifeq ($(XDG_CONFIG_HOME),)
CONFIG := $(HOME)/.config
else
CONFIG := $(XDG_CONFIG_HOME)
endif

.PHONY: conf
conf:

	@mkdir -p $(CONFIG)

	@for f in nvim mpv zsh; do \
		echo "  - $$f -> $(CONFIG)/$$f"; \
		ln -sf $$(realpath $$f) $(CONFIG); \
	done

	@for f in .zshrc .skhdrc .tmux.conf .tigrc .gitconfig .gitignore_global .eslintrc.yml; do \
		echo "  - $$f -> $(HOME)/$$f"; \
		ln -sf $$(realpath $$f) $(HOME); \
	done

