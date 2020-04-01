#!/usr/bin/env bash

PERENNIAL_SETTINGS_FILE="perennial-settings.sh"
echo "#!/usr/bin/env bash" > $PERENNIAL_SETTINGS_FILE
echo "# Paste your personal settings here" >> $PERENNIAL_SETTINGS_FILE
echo "" >> $PERENNIAL_SETTINGS_FILE
vim -c ":$" $PERENNIAL_SETTINGS_FILE

chmod +x $PERENNIAL_SETTINGS_FILE
source $PERENNIAL_SETTINGS_FILE

if [[ -z ${SSH_PRIVATE_KEY} ]]; then
  rm --force $HOME/.ssh/id_rsa $HOME/.ssh/id_rsa.pub
  ssh-keygen -t rsa -b 4096 -q -N "" -C "" -f $HOME/.ssh/id_rsa
else
  mkdir -p $HOME/.ssh
  touch $HOME/.ssh/id_rsa
  echo "$SSH_PRIVATE_KEY" > $HOME/.ssh/id_rsa
  touch $HOME/.ssh/id_rsa.pub
  echo $SSH_PUBLIC_KEY > $HOME/.ssh/id_rsa.pub
fi

touch $HOME/.ssh/config
echo "Host github.com" > $HOME/.ssh/config
echo "User git" >> $HOME/.ssh/config
echo "Hostname github.com" >> $HOME/.ssh/config
echo "PreferredAuthentications publickey" >> $HOME/.ssh/config
echo "IdentityFile $HOME/.ssh/id_rsa" >> $HOME/.ssh/config

touch $HOME/.ssh/authorized_keys
cat $HOME/.ssh/id_rsa.pub > $HOME/.ssh/authorized_keys
eval "$(ssh-agent -s)"
ssh-add -qv $HOME/.ssh/id_rsa
chmod --recursive 700 $HOME/.ssh
ssh -o StrictHostKeyChecking=no -vT git@github.com

git config --global user.name $GIT_USERNAME
git config --global user.email $GIT_EMAIL

mkdir -p ~/git
cd git
# iterate through comma separated list and git clone for each
for i in $(echo $GIT_REPOSITORIES | sed "s/,/ /g")
do
  git clone $i
done
cd ..

NPM_TOKEN=$(curl --silent \
  -H "Accept: application/json" \
  -H "Content-Type:application/json" \
  -X PUT --data '{"name": "$NPM_USERNAME", "password": "$NPM_PASSWORD"}' \
  https://registry.npmjs.org/-/user/org.couchdb.user:$NPM_USERNAME 2>&1 | grep -Po \
  '(?<="token": ")[^"]*')
npm set registry "https://registry.npmjs.org"
npm set https://registry.npmjs.org/:_authToken $NPM_TOKEN

mkdir -p ~/.aws
echo "$AWS_CREDENTIALS" > ~/.aws/credentials

shred --zero --remove $PERENNIAL_SETTINGS_FILE
