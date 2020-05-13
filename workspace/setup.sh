#!/usr/bin/env bash
set -e

apt-get -q update
apt-get install -y apt-utils
apt-get install -y software-properties-common
apt-get -q update
apt-get upgrade -y
apt-get autoremove -y

apt-get install -y sudo
apt-get install -y locales
apt-get install -y build-essential
apt-get install -y net-tools
apt-get install -y wget
apt-get install -y curl
apt-get install -y apt-transport-https
apt-get install -y vim
apt-get install -y file
apt-get install -y gnupg
apt-get install -y bzip2
apt-get install -y python-numpy
apt-get install -y unzip
apt-get install -y jq
apt-get install -y git

useradd -ms /bin/bash -u 1000 user

locale-gen en_US.UTF-8
LANG='en_US.UTF-8'
LANGUAGE='en_US:en'
LC_ALL='en_US.UTF-8'
FONTCONFIG_PATH='/etc/fonts/'

cp $BUILD_DIRECTORY/script/.bashrc $HOME/.bashrc
cp -r $BUILD_DIRECTORY/setup/content/.config $HOME/.config

find $BUILD_DIRECTORY/setup/content/tools -name '*.sh' -exec chmod a+x {} +
cp $BUILD_DIRECTORY/setup/content/tools/* /usr/local/bin

chown -R user:user $HOME

echo "Install brew via git clone as directed by https://docs.brew.sh/Homebrew-on-Linux#alternative-installation"
git clone https://github.com/Homebrew/brew $HOME/.linuxbrew/Homebrew
mkdir $HOME/.linuxbrew/bin
ln -s $HOME/.linuxbrew/Homebrew/bin/brew $HOME/.linuxbrew/bin
eval $($HOME/.linuxbrew/bin/brew shellenv)
brew update
brew upgrade
brew --version
brew install sops
brew install terraform
brew install kubectl
brew install kops
brew install helm

echo "Install nodejs as directed by https://github.com/nodesource/distributions/blob/master/README.md#debinstall"
curl --silent https://deb.nodesource.com/setup_12.x | bash -
apt-get install -y nodejs

echo "Install AWS CLI as directed by https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$HOME/awscliv2.zip"
unzip $HOME/awscliv2.zip
sudo $HOME/aws/install
rm -rf $HOME/aws $HOME/awscliv2.zip
aws --version

echo "Install VS Code as directed by https://code.visualstudio.com/docs/setup/linux"
curl --silent https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
apt-get update
apt-get install -y code
rm ~/microsoft.gpg
sudo -u user code --install-extension mtxr.sqltools
sudo -u user code --install-extension eamodio.gitlens
sudo -u user code --install-extension mauve.terraform
sudo -u user code --install-extension ms-vscode-remote.remote-ssh
echo "{
    \"workbench.startupEditor\": \"newUntitledFile\",
    \"editor.renderWhitespace\": \"all\",
    \"editor.minimap.enabled\": false,
    \"extensions.ignoreRecommendations\": true,
    \"terminal.integrated.shell.linux\": \"/bin/bash\",
    \"workbench.statusBar.visible\": false,
}" >> $HOME/.config/Code/User/settings.json
