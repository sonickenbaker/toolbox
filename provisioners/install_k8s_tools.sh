#!/bin/bash

INSTALL_FOLDER="/usr/local/bin"

# Download and install kubectl
KUBECTL_LATEST_STABLE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
KUBECTL_VERSION=${1:-$KUBECTL_LATEST_STABLE_VERSION}

echo "===> Downloading Kubectl from: https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl "$INSTALL_FOLDER/kubectl"


# Download and install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm ./get_helm.sh

# Download and install K9s
wget https://github.com/derailed/k9s/releases/download/v0.25.21/k9s_Linux_x86_64.tar.gz
mkdir ./k9s
tar -xvf k9s_Linux_x86_64.tar.gz -C ./k9s
sudo mv ./k9s/k9s "$INSTALL_FOLDER/"
rm -rf ./k9s k9s_Linux_x86_64.tar.gz

# Download and install istioctl
export ISTIO_VERSION="1.14.1"
export TARGET_ARCH="x86_64"

curl -LO https://istio.io/downloadIstio
chmod +x downloadIstio
./downloadIstio
sudo mv "./istio-$ISTIO_VERSION/bin/istioctl" "$INSTALL_FOLDER/"