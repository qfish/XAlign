# Set up the environment.

    PACKAGE="XAlign.tar.gz"
    PLUGIN_DIR="$HOME/Library/Application Support/Developer/Shared/Xcode/Plug-ins"
    XALIGN_PATH="$PLUGIN_DIR/XAlign.xcplugin"
    DOMAIN="http://qfi.sh"

# check path, create dir if not exist, remove id 
    
    if [ ! -d "$PLUGIN_DIR" ]; then
       sudo mkdir -p "$PLUGIN_DIR"
    else
        if [ -d "$PLUGIN_DIR" ]; then
          sudo rm -rf "$XALIGN_PATH"
        fi
    fi

# Download the package and unpack it.

  sudo curl -o "$PACKAGE" $DOMAIN/XAlign/build/"$PACKAGE"
  # sudo wget $DOMAIN/XAlign/build/"$PACKAGE" -O "$PACKAGE"
  sudo tar xzf "$PACKAGE" -C "$PLUGIN_DIR"

# remove tmp files
  
  sudo rm -rf "$PACKAGE"

# done 
  echo
  echo "XAlign is update. Please Restart Your Xcode."
  echo
  echo "More info: https://github.com/qfish/XAlign/"
  echo
  echo "To uninstall XAlign, \`curl $DOMAIN/XAlign/build/uninstall.sh | sh\`"
  echo "."