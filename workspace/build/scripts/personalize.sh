#!/usr/bin/env bash

SETTINGS_FILE="settings.sh"
echo "#!/usr/bin/env bash" > $SETTINGS_FILE
echo "# Paste your personal settings here" >> $SETTINGS_FILE
echo "" >> $SETTINGS_FILE
vim -c ":$" $SETTINGS_FILE

chmod +x $SETTINGS_FILE
source $SETTINGS_FILE

mkdir -p $HOME/.ssh
if [[ -z ${SSH_PRIVATE_KEY} ]]; then
  rm --force $HOME/.ssh/id_rsa $HOME/.ssh/id_rsa.pub
  ssh-keygen -t rsa -b 4096 -q -N "" -C "" -f $HOME/.ssh/id_rsa
else
  echo "$SSH_PRIVATE_KEY" > $HOME/.ssh/id_rsa
  echo $SSH_PUBLIC_KEY > $HOME/.ssh/id_rsa.pub
fi

echo "Host github.com" > $HOME/.ssh/config
echo "User git" >> $HOME/.ssh/config
echo "Hostname github.com" >> $HOME/.ssh/config
echo "PreferredAuthentications publickey" >> $HOME/.ssh/config
echo "IdentityFile $HOME/.ssh/id_rsa" >> $HOME/.ssh/config

cat $HOME/.ssh/id_rsa.pub > $HOME/.ssh/authorized_keys
eval "$(ssh-agent -s)"
ssh-add -qv $HOME/.ssh/id_rsa
chmod --recursive 700 $HOME/.ssh
ssh -o StrictHostKeyChecking=no -vT git@github.com

git config --global user.name $GIT_USERNAME
git config --global user.email $GIT_EMAIL

mkdir -p $HOME/git
cd $HOME/git
# iterate through comma separated list and git clone for each
for i in $(echo $GIT_REPOSITORIES | sed "s/,/ /g")
do
  git clone $i
done
cd $HOME

# npm login command cannot be used without live user input. Use the api directly with curl.
NPM_TOKEN=$(curl --silent \
  -H "Accept: application/json" \
  -H "Content-Type:application/json" \
  -X PUT --data '{"name": "$NPM_USERNAME", "password": "$NPM_PASSWORD"}' \
  https://registry.npmjs.org/-/user/org.couchdb.user:$NPM_USERNAME 2>&1 | grep -Po \
  '(?<="token": ")[^"]*')
npm set registry "https://registry.npmjs.org"
npm set https://registry.npmjs.org/:_authToken $NPM_TOKEN

mkdir -p $HOME/.aws
echo "$AWS_CREDENTIALS" > $HOME/.aws/credentials

shred --zero --remove $SETTINGS_FILE
