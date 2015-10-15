#!/usr/bin/env bash

# Set up the environment.

PLUGIN_DIR="$HOME/Library/Application Support/Developer/Shared/Xcode/Plug-ins"
XALIGN_PATH="$PLUGIN_DIR/XAlign.xcplugin"
DOMAIN="http://qfi.sh"

# check path, remove if exist

if [ -d "$PLUGIN_DIR" ]; then
    if [ -d "$XALIGN_PATH" ]; then
        echo ""
        echo "Remove $XALIGN_PATH"
        rm -rf "$XALIGN_PATH"
    fi
fi

echo ""
echo "Downloading XAlign..."

# Prepare
mkdir -p /var/tmp/XAlign.tmp && cd /var/tmp/XAlign.tmp

echo ""
# Clone from git
git clone https://github.com/qfish/XAlign.git --depth 1 /var/tmp/XAlign.tmp > /dev/null

echo ""
echo "Installing XAlign..."

# Then build
xcodebuild clean > /dev/null
xcodebuild > /dev/null

# Remove tmp files
cd ~
rm -rf /var/tmp/XAlign.tmp

# Done
echo ""
echo "XAlign successfully installed! 🍻   Please restart your Xcode."
echo ""