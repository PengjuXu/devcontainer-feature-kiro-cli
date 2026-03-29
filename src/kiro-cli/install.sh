#!/bin/bash
set -e

ARCH=$(uname -m)
if [ "${ARCH}" = "x86_64" ]; then
    URL="https://desktop-release.q.us-east-1.amazonaws.com/latest/kirocli-x86_64-linux.zip"
elif [ "${ARCH}" = "aarch64" ] || [ "${ARCH}" = "arm64" ]; then
    URL="https://desktop-release.q.us-east-1.amazonaws.com/latest/kirocli-aarch64-linux.zip"
else
    echo "Arch unsupported: ${ARCH}"
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -y curl unzip

curl --proto '=https' --tlsv1.2 -sSf "${URL}" -o "kirocli.zip"
unzip -q kirocli.zip

# Runs as root during feature build, installs to /root/.local/bin
bash ./kirocli/install.sh --no-confirm

# Move to global path for non-root access (e.g., vscode user)
mv /root/.local/bin/kiro-cli /usr/local/bin/kiro-cli
chmod +x /usr/local/bin/kiro-cli

rm -rf kirocli kirocli.zip
echo "Kiro CLI installed."
