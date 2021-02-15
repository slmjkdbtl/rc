# wengwengweng

CONFIG := $(HOME)/.config

.PHONY: conf
conf:

	@mkdir -p $(CONFIG)

	@for f in nvim mpv zsh alacritty.yml; do \
		echo "  - $$f -> $(CONFIG)/$$f"; \
		ln -sf $$(realpath $$f) $(CONFIG); \
	done

	@for f in .vim .scripts .zshrc .skhdrc .tmux.conf .gitconfig .gitignore_g .eslintrc.yml; do \
		echo "  - $$f -> $(HOME)/$$f"; \
		ln -sf $$(realpath $$f) $(HOME); \
	done

