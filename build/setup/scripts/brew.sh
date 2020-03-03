#!/usr/bin/env bash
set -e

# echo "Install brew as directed by https://docs.brew.sh/Homebrew-on-Linux"

# sudo -u user sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

# test -d $HOME/.linuxbrew && eval $($HOME/.linuxbrew/bin/brew shellenv)
# test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
# test -r $HOME/.bashrc && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> $HOME/.bashrc
# echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> $HOME/.bashrc

echo "Install brew via git clone as directed by https://docs.brew.sh/Homebrew-on-Linux#alternative-installation"
git clone https://github.com/Homebrew/brew $HOME/.linuxbrew/Homebrew
mkdir $HOME/.linuxbrew/bin
ln -s $HOME/.linuxbrew/Homebrew/bin/brew $HOME/.linuxbrew/bin
eval $($HOME/.linuxbrew/bin/brew shellenv)

brew update
brew install sops
brew install terraform
brew install kops
brew install kubectl
brew install helm

# brew install bash-completion
# brew install kube-ps1