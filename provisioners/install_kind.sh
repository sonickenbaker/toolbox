#!/bin/bash

KIND_VERSION="v0.14.0"
ARCH="$(dpkg --print-architecture)"
KIND_BINARY="$HOME/kind"
INSTALL_FOLDER="/usr/local/bin"

# Download kind binary
echo "===> Downloading Kind from: https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-$ARCH"
curl -Lo "$KIND_BINARY" "https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-$ARCH"
chmod +x "$KIND_BINARY"
sudo mv "$KIND_BINARY" "$INSTALL_FOLDER"

# Try-it out
kind --version