# Set up the environment.

    PACKAGE="XAlign.tar.gz"
    PLUGIN_DIR="$HOME/Library/Application Support/Developer/Shared/Xcode/Plug-ins"
    XALIGN_PATH="$PLUGIN_DIR/XAlign.xcplugin"

# check path, create dir if not exist, remove id 
    
    if [ ! -d "$PLUGIN_DIR" ]; then
       sudo mkdir -p "$PLUGIN_DIR"
    else
        if [ -d "$PLUGIN_DIR" ]; then
            rm -rf "$XALIGN_PATH"
        fi
    fi

# Download the package and unpack it.

  sudo wget github.so/XAlign/build/"$PACKAGE" -O "$PACKAGE"
  tar xzf "$PACKAGE" -C "$PLUGIN_DIR"

# remove tmp files
  
  rm -rf "$PACKAGE"

# done 
  echo
  echo "XAlign is installed."
  echo
  echo "More info: https://github.com/qfish/XAlign/"
  echo
  echo "To uninstall XAlign, \`curl github.so/build/uninstall.sh | sh\`"
  echo "."