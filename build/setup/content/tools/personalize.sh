#!/usr/bin/env bash

PERENNIAL_SETTINGS_FILE="perennial-settings.sh"
echo "#!/usr/bin/env bash" > $PERENNIAL_SETTINGS_FILE
echo "# Paste your personal settings here" >> $PERENNIAL_SETTINGS_FILE
echo "" >> $PERENNIAL_SETTINGS_FILE
vim -c ":$" $PERENNIAL_SETTINGS_FILE

# load the variables from the file (ignoring comments)
# $(cat $PERENNIAL_SETTINGS_FILE | sed -e '/^#/d' | xargs)
chmod +x $PERENNIAL_SETTINGS_FILE
source $PERENNIAL_SETTINGS_FILE

if [ -z ${SSH_PRIVATE_KEY} ]; then
	rm --force $HOME/.ssh/id_rsa $HOME/.ssh/id_rsa.pub
	ssh-keygen -t rsa -b 4096 -q -N "" -C "" -f $HOME/.ssh/id_rsa
else 
	echo $SSH_PRIVATE_KEY > $HOME/.ssh/id_rsa
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
npm set //your_registry/:_authToken $NPM_TOKEN

AWS_REGION="us-west-2"
AWS_OUTPUT_FORMAT="json"
echo "${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
${AWS_OUTPUT_FORMAT}" | aws configure

shred --zero --remove $PERENNIAL_SETTINGS_FILE
