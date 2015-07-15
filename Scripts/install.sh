#!/usr/bin/env bash

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
echo "XAlign successfully installed! 🍻 Please restart your Xcode."
echo ""