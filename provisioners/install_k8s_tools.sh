#!/bin/bash

DOWNLOAD_FOLDER="/tmp/provision"
INSTALL_FOLDER="/usr/local/bin"

# setup
mkdir "$DOWNLOAD_FOLDER"

# Kubectl
KUBECTL_LATEST_STABLE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
KUBECTL_VERSION=${1:-$KUBECTL_LATEST_STABLE_VERSION}
KUBECTL_URL="https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
KUBECTL_BIN="$DOWNLOAD_FOLDER/kubectl"
echo "===> Installing kubectl"
curl -L -o "$KUBECTL_BIN" "$KUBECTL_URL"
sudo install -o root -g root -m 0755 "$KUBECTL_BIN" "$INSTALL_FOLDER/kubectl"


# Helm
HELM_SCRIPT="$DOWNLOAD_FOLDER/get_helm.sh"
HELM_URL="https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3"
echo "===> Installing Helm"
curl -fsSL -o "$HELM_SCRIPT" "$HELM_URL"
chmod 700 "$HELM_SCRIPT"
"$HELM_SCRIPT"
#rm "$HELM_SCRIPT"

# K9s
K9S_DIR="$DOWNLOAD_FOLDER/k9s"
K9S_URL="https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_x86_64.tar.gz"
echo "===> Installing k9s"
mkdir "$K9S_DIR"
wget -P "$K9S_DIR/" "$K9S_URL"
tar -xvf "$K9S_DIR/k9s_Linux_x86_64.tar.gz" -C "$K9S_DIR"
sudo install -o root -g root -m 0755 "$K9S_DIR/k9s" "$INSTALL_FOLDER/"

# istioctl
export ISTIO_VERSION="1.14.1"
export TARGET_ARCH="x86_64"
ISTIO_DOWNLOAD="$DOWNLOAD_FOLDER/downloadIstio"
ISTIO_URL="https://istio.io/downloadIstio"
echo "===> Installing istioctl"
curl -L -o "$ISTIO_DOWNLOAD" "$ISTIO_URL"
chmod +x "$ISTIO_DOWNLOAD"
pushd "$(pwd)" || exit
cd "$DOWNLOAD_FOLDER" || exit
./"$ISTIO_DOWNLOAD"
popd || exit
sudo install -o root -g root -m 0755 "$DOWNLOAD_FOLDER/istio-$ISTIO_VERSION/bin/istioctl" "$INSTALL_FOLDER/"