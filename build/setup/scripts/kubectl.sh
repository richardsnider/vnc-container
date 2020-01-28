#!/usr/bin/env bash
set -e

echo "Install kubectl as directed by https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux"

curl --silent https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
apt-get -q update 
apt-get install -y kubectl
