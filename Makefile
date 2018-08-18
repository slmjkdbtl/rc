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
	echo "+ creating ~/.vim"
	echo "  - copying"
	rm -rf $(HOME)/.vim
	cp -r $(realpath nvim) $(HOME)/.vim
	echo "  - renaming init.vim to vimrc"
	mv $(HOME)/.vim/init.vim $(HOME)/.vim/vimrc
	echo "  - downloading vim-plug"
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

