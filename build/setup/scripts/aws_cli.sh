#!/usr/bin/env bash
set -ex

echo "As directed by https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$HOME/awscliv2.zip"
unzip $HOME/awscliv2.zip
sudo $HOME/aws/install
rm -rf $HOME/aws $HOME/awscliv2.zip

aws --version
