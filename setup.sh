#!/usr/bin/env bash
set -e

# useradd -ms /bin/bash -u 1000 user
# export HOME=/home/user
# export BUILD_DIRECTORY=$HOME/build
# export TERM=xterm
# export DEBIAN_FRONTEND=noninteractive
cd $HOME

sudo apt-get --quiet update
sudo apt-get install --yes apt-utils
sudo apt-get install --yes software-properties-common
sudo apt-get --quiet update
sudo apt-get upgrade --yes
sudo apt-get autoremove --yes

sudo apt-get install --yes sudo
sudo apt-get install --yes locales
sudo apt-get install --yes build-essential
sudo apt-get install --yes net-tools
sudo apt-get install --yes wget
sudo apt-get install --yes curl
sudo apt-get install --yes apt-transport-https
sudo apt-get install --yes ca-certificates
sudo apt-get install --yes vim
sudo apt-get install --yes file
sudo apt-get install --yes gnupg
sudo apt-get install --yes gnupg-agent
sudo apt-get install --yes bzip2
sudo apt-get install --yes python-numpy
sudo apt-get install --yes unzip
sudo apt-get install --yes jq
sudo apt-get install --yes git
sudo apt-get install --yes fonts-liberation 
sudo apt-get install --yes xdg-utils

sudo locale-gen en_US.UTF-8
export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'
export FONTCONFIG_PATH='/etc/fonts/'

sudo apt-get install --yes qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-top
sudo adduser `id -un` libvirt
sudo adduser `id -un` kvm
kvm-ok

echo "Install Docker as directed by https://docs.docker.com/engine/install/ubuntu/"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install --yes docker-ce docker-ce-cli containerd.io

sudo add-apt-repository ppa:hluk/copyq
sudo apt-get update
sudo apt-get install --yes copyq

sudo apt-get install --yes chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg
ln -s /usr/bin/chromium-browser /usr/bin/google-chrome

echo "Install nodejs as directed by https://github.com/nodesource/distributions/blob/master/README.md#debinstall"
curl --silent https://deb.nodesource.com/setup_12.x | bash -
sudo apt-get install -y nodejs

echo "Install AWS CLI as directed by https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html"
curl --silent https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip --output $HOME/awscliv2.zip
unzip $HOME/awscliv2.zip
sudo $HOME/aws/install
rm -rf $HOME/aws $HOME/awscliv2.zip

echo "Install VS Code as directed by https://code.visualstudio.com/docs/setup/linux"
curl --silent https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get update
sudo apt-get install -y code
rm ~/microsoft.gpg
code --install-extension mtxr.sqltools
code --install-extension eamodio.gitlens
echo "{
    \"workbench.startupEditor\": \"newUntitledFile\",
    \"editor.renderWhitespace\": \"all\",
    \"editor.minimap.enabled\": false,
    \"extensions.ignoreRecommendations\": true,
    \"terminal.integrated.shell.linux\": \"/bin/bash\",
    \"workbench.statusBar.visible\": false,
}" >> $HOME/.config/Code/User/settings.json

echo "Install brew via git clone as directed by https://docs.brew.sh/Homebrew-on-Linux#alternative-installation"
git clone https://github.com/Homebrew/brew $HOME/.linuxbrew/Homebrew
mkdir $HOME/.linuxbrew/bin
ln -s $HOME/.linuxbrew/Homebrew/bin/brew $HOME/.linuxbrew/bin
eval $($HOME/.linuxbrew/bin/brew shellenv)
brew update
brew upgrade
brew install sops
brew install pulumi
brew install kops
brew install kubectl

curl --silent github.com/vorprog/scripts/aws-mfa.sh --output /usr/local/bin/aws-mfa.sh && chmod +x /usr/local/bin/aws-mfa.sh
curl --silent github.com/vorprog/scripts/personalize.sh --output /usr/local/bin/personalize.sh && chmod +x /usr/local/bin/personalize.sh
curl --silent github.com/vorprog/scripts/set-aliases.sh --output /usr/local/bin/set-aliases.sh && chmod +x /usr/local/bin/set-aliases.sh
curl --silent github.com/vorprog/scripts/.bashrc --output $HOME/.bashrc

# chown -R user:user $HOME
