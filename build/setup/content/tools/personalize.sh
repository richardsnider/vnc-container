#!/usr/bin/env bash

PERENNIAL_SETTINGS_FILE="perennial.settings"
touch $PERENNIAL_SETTINGS_FILE
echo "# Paste your personal settings here"
vim $PERENNIAL_SETTINGS_FILE

# load the variables from the file (ignoring comments)
$(cat $PERENNIAL_SETTINGS_FILE | sed -e '/^#/d' | xargs)

ssh-keygen -t rsa -b 4096 -q -N "" -f $HOME/.ssh/id_rsa
echo $SSH_PRIVATE_KEY >> $HOME/.ssh/id_rsa
echo $SSH_PUBLIC_KEY >> $HOME/.ssh/id_rsa.pub

echo "Host github.com" >> $HOME/.ssh/config
echo "User git" >> $HOME/.ssh/config
echo "Hostname github.com" >> $HOME/.ssh/config
echo "PreferredAuthentications publickey" >> $HOME/.ssh/config
echo "IdentityFile $HOME/.ssh/id_rsa" >> $HOME/.ssh/config

cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
eval "$(ssh-agent -s)"
ssh-add $HOME/.ssh/id_rsa

chmod --recursive 700 $HOME/.ssh

git config --global user.name $GIT_USERNAME
git config --global user.email $GIT_EMAIL

mkdir ~/git
cd git
# iterate through comma separated list and git clone for each
for i in $(echo $GIT_REPOSITORIES | sed "s/,/ /g")
do
	git clone $i
done
cd ..

echo "${NPM_USERNAME}\n${NPM_PASSWORD}\n${NPM_EMAIL}" | npm login --registry=https://registry.npmjs.org --scope=@$NPM_ORG_NAME

AWS_REGION="us-west-2"
AWS_OUTPUT_FORMAT="json"
echo "${AWS_ACCESS_KEY_ID}\n${AWS_SECRET_ACCESS_KEY}\n${AWS_REGION}\n${AWS_OUTPUT_FORMAT}" | aws configure

shred --zero --remove $PERENNIAL_SETTINGS_FILE
