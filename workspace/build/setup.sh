#!/usr/bin/env bash
set -e

useradd -ms /bin/bash -u 1000 user

echo "Setup ssh server"
mkdir /var/run/sshd
echo 'user:foobar' | chpasswd
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
mkdir $HOME/.ssh

echo "Add scripts"
find $BUILD_DIRECTORY/scripts -name '*.sh' -exec chmod a+x {} +
cp $BUILD_DIRECTORY/scripts/* /usr/local/bin
cp $BUILD_DIRECTORY/.bashrc $HOME/.bashrc
chown -R user:user $HOME

# echo "Install brew via git clone as directed by https://docs.brew.sh/Homebrew-on-Linux#alternative-installation"
# git clone https://github.com/Homebrew/brew $HOME/.linuxbrew/Homebrew
# mkdir $HOME/.linuxbrew/bin
# ln -s $HOME/.linuxbrew/Homebrew/bin/brew $HOME/.linuxbrew/bin
# eval $($HOME/.linuxbrew/bin/brew shellenv)
# brew update
# brew upgrade
# brew --version
# brew install sops
# brew install terraform
# brew install kubectl
# brew install kops
# brew install helm

# echo "Install nodejs as directed by https://github.com/nodesource/distributions/blob/master/README.md#debinstall"
# curl --silent https://deb.nodesource.com/setup_12.x | bash -
# apt-get install -y nodejs

# echo "Install AWS CLI as directed by https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html"
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$HOME/awscliv2.zip"
# unzip $HOME/awscliv2.zip
# sudo $HOME/aws/install
# rm -rf $HOME/aws $HOME/awscliv2.zip
# aws --version

# echo "Install VS Code as directed by https://code.visualstudio.com/docs/setup/linux"
# curl --silent https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
# sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
# apt-get update
# apt-get install -y code
# rm ~/microsoft.gpg
# sudo -u user code --install-extension mtxr.sqltools
# sudo -u user code --install-extension eamodio.gitlens
# sudo -u user code --install-extension mauve.terraform
# sudo -u user code --install-extension ms-vscode-remote.remote-ssh
# echo "{
#     \"workbench.startupEditor\": \"newUntitledFile\",
#     \"editor.renderWhitespace\": \"all\",
#     \"editor.minimap.enabled\": false,
#     \"extensions.ignoreRecommendations\": true,
#     \"terminal.integrated.shell.linux\": \"/bin/bash\",
#     \"workbench.statusBar.visible\": false,
# }" >> $HOME/.config/Code/User/settings.json
