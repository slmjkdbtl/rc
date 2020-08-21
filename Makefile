# wengwengweng

# TODO: don't use GNU Make
ifeq ($(XDG_CONFIG_HOME),)
	CONFIG := $(HOME)/.config
else
	CONFIG := $(XDG_CONFIG_HOME)
endif

.PHONY: conf
conf:

	@echo "+ linking"

	@mkdir -p $(CONFIG)

	$(foreach f, nvim fish alacritty mpv mutt kak, \
		echo "  - $(f) -> $(CONFIG)/$(f)"; \
		ln -sf $(realpath $(f)) $(CONFIG); \
	)

	$(foreach f, .yabairc .skhdrc .tmux.conf .procs.toml .tigrc .gitconfig .gitignore_global .eslintrc.yml, \
		echo "  - $(f) -> $(HOME)/$(f)"; \
		ln -sf $(realpath $(f)) $(HOME); \
	)

	@echo "+ ticcing terminfos"
	@tic $(realpath super.terminfo)

.PHONY: setup-macos
@setup-macos:

	sudo -v

	@read -p "hostname: " hname; \
		scutil --set ComputerName $$hname; \
		scutil --set HostName $$hname; \
		scutil --set LocalHostName $$hname; \

	echo "+ installing developer tools"
	xcode-select --install

	echo "+ installing homebrew"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	echo "+ installing fish"
	brew install fish

	echo "+ installing neovim"
	brew install neovim

	echo "+ changing default shell to fish"
	chsh -s /usr/local/bin/fish $$USER

	echo "+ linking configs"
	make

	echo "DONE"

.PHONY: setup-centos
setup-centos:

	sudo -v

	@read -p "hostname: " hname; \
		hostname $$hname

	@read -p "username: " uname; \
		adduser $$uname

	echo "+ installing fish"
	cd /etc/yum.repos.d/; \
		wget https://download.opensuse.org/repositories/shells:fish:release:3/RHEL_7/shells:fish:release:3.repo
	yum install fish

	echo "+ installing neovim"
	yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	yum install -y neovim

	echo "+ changing default shell to fish"
	chsh -s /usr/bin/fish $$USER

	echo "+ linking configs"
	make

	echo "DONE"

