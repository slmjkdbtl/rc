# wengwengweng

NVIM = ~/.config
FISH = ~/.config
SKHDRC = ~

.PHONY: link
link:

	echo "+ linking"
	echo "  - nvim"
	ln -sf $(realpath nvim) $(NVIM)
	echo "  - fish"
	ln -sf $(realpath fish) $(FISH)
	echo "  - .skhdrc"
	ln -sf $(realpath .skhdrc) $(SKHDRC)


