CONFIG := $(HOME)/.config

.PHONY: install
install:

	@mkdir -p $(CONFIG)

	@for f in mpv fish; do \
		echo "$$f -> $(CONFIG)/$$f"; \
		ln -sf $$(realpath $$f) $(CONFIG); \
	done

	@for f in vim scripts skhdrc tmux.conf gitconfig wezterm.lua eslintrc.json; do \
		echo "$$f -> $(HOME)/.$$f"; \
		ln -sf $$(realpath $$f) $(HOME)/.$$f; \
	done
