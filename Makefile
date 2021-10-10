CONFIG := $(HOME)/.config
USERBIN := $(HOME)/.local/bin

.PHONY: install
install:

	@mkdir -p $(CONFIG)
	@mkdir -p $(USERBIN)

	@for f in nvim mpv fish; do \
		echo "$$f -> $(CONFIG)/$$f"; \
		ln -sf $$(realpath $$f) $(CONFIG); \
	done

	@for f in vim dshrc skhdrc tmux.conf gitconfig wezterm.lua eslintrc.json; do \
		echo "$$f -> $(HOME)/.$$f"; \
		test -L $(HOME)/.$$f && test -d $(HOME)/.$$f && rm $(HOME)/.$$f; \
		ln -sf $$(realpath $$f) $(HOME)/.$$f; \
	done

	@for f in $(shell ls scripts); do \
		echo "$$f -> $(USERBIN)/$$f"; \
		ln -sf $$(realpath scripts/$$f) $(USERBIN); \
	done
