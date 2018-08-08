# wengwengweng

ifeq ($(XDG_CONFIG_HOME),)
	CONFIG := $(HOME)/.config
else
	CONFIG := $(XDG_CONFIG_HOME)
endif

TOCONFIG = nvim fish mpv scripts
TOHOME = .skhdrc .tmux.conf .tigrc

.PHONY: conf
conf:

	echo "+ linking"

	$(foreach f, $(TOCONFIG), \
		echo "  - $(f) -> $(CONFIG)/$(f)"; \
		ln -sf $(realpath $(f)) $(CONFIG); \
	)

	$(foreach f, $(TOHOME), \
		echo "  - $(f) -> $(HOME)/$(f)"; \
		ln -sf $(realpath $(f)) $(HOME); \
	)

	echo "+ ticcing terminfos"
	tic $(realpath super.terminfo)
	echo "+ copying nvim to ~/.vim"
	rm -rf $(HOME)/.vim
	cp -r $(realpath nvim) $(HOME)/.vim
	mv $(HOME)/.vim/init.vim $(HOME)/.vim/vimrc
	mv $(HOME)/.vim/misc $(HOME)/.vim/autoload

