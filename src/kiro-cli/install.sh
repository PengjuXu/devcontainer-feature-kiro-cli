#!/bin/bash
set -e

# 1. Setup Env
USERNAME=${_REMOTE_USER:-"vscode"}
ARCH=$(uname -m)

if [ "${ARCH}" = "x86_64" ]; then
    URL="https://desktop-release.q.us-east-1.amazonaws.com/latest/kirocli-x86_64-linux.zip"
elif [ "${ARCH}" = "aarch64" ] || [ "${ARCH}" = "arm64" ]; then
    URL="https://desktop-release.q.us-east-1.amazonaws.com/latest/kirocli-aarch64-linux.zip"
else
    echo "Arch unsupported: ${ARCH}"; exit 1
fi

# 2. Dependencies
apt-get update && apt-get install -y curl unzip

# 3. Download
curl -sSfL "${URL}" -o "kirocli.zip"
unzip -q kirocli.zip

# 4. Install as non-root user
# We use 'su' to switch to the devcontainer user to bypass the root check
chown -R $USERNAME:$USERNAME ./kirocli
su $USERNAME -c "bash ./kirocli/install.sh --no-confirm"

# 5. Make it global
# Installer puts it in /home/$USERNAME/.local/bin/kiro-cli
LOCAL_BIN="/home/$USERNAME/.local/bin"
if [ -f "$LOCAL_BIN" ]; then
    cp "$LOCAL_BIN/kiro-cli" /usr/local/bin/kiro-cli
    cp "$LOCAL_BIN/kiro-cli-chat" /usr/local/bin/kiro-cli-chat
    cp "$LOCAL_BIN/kiro-cli-term" /usr/local/bin/kiro-cli-term
    
    # short names
    ln -s /usr/local/bin/kiro-cli /usr/local/bin/kiro
    ln -s /usr/local/bin/kiro-cli-chat /usr/local/bin/kiro-chat
    ln -s /usr/local/bin/kiro-cli-term /usr/local/bin/kiro-term
    chmod +x /usr/local/bin/kiro*
fi

rm -rf kirocli kirocli.zip
echo "Kiro CLI installed successfully."
