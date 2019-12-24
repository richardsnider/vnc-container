#!/usr/bin/env bash
set -e

kopsDownloadPath=$(curl --silent https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)
curl https://github.com/kubernetes/kops/releases/download/$kopsDownloadPath/kops-linux-amd64 --output kops
chmod +x ./kops
mv ./kops /usr/local/bin/