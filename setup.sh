# wengwengweng

sudo -v

# install developer tools
xcode-select --install

# computer names
read -p "hostname: " hname
sudo scutil --set ComputerName "$hname"
read -p "computername: " cpname
sudo scutil --set HostName "$cpname"
read -p "localhostname: " lhname
sudo scutil --set LocalHostName "$lhname"

# git config
read -p "git username: " git_name
git config --global user.name "$git_name"
read -p "git email: " git_email
git config --global user.email "$git_email"
git config --global color.ui true

# copy configs
make install

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install important softwares
brew install fish
brew install neovim

# set default shell
sudo chsh -s /usr/local/bin/fish

# finder show path
defaults write com.apple.finder ShowPathbar -bool true

