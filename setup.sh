# script for setting up a new mac

echo "installing xcode command line tools"
sudo xcode-select --install
echo "generating ssh key"
ssh-keygen -t rsa
echo "linking /bin/sh to /bin/dash"
sudo ln -sf /bin/dash /var/select/sh
echo "disabling gate keeper"
sudo spctl --master-disable
echo "installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "installing configs"
make
echo "installing brew packages"
brew bundle install
