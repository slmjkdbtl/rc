# wengwengweng

CONFIG := $(HOME)/.config

.PHONY: conf
conf:

	@mkdir -p $(CONFIG)

	@for f in mpv fish alacritty.yml; do \
		echo "- $$f -> $(CONFIG)/$$f"; \
		ln -sf $$(realpath $$f) $(CONFIG); \
	done

	@for f in .vim .scripts .skhdrc .tmux.conf .gitconfig .gitignore_g .eslintrc.yml .wezterm.lua; do \
		echo "- $$f -> $(HOME)/$$f"; \
		ln -sf $$(realpath $$f) $(HOME); \
	done
