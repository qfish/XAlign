XAlign
======

A useful Xcode plugin to align regular code. It can align anything by using custom alignment patterns.

## What's XAlign

Here are some example alignment patterns. Of course you can make your own. The example files are under the `main` dir. Just try it yourself.

### Align by equals sign
![Equal](http://github.so/XAlign/images/equal.gif)

### Align by define group
![Define](http://github.so/XAlign/images/define.gif)

### Align by property group
![Property](http://github.so/XAlign/images/property.gif)

## Install & Update

### Via command-line

   ```sh
    # install
    $ curl github.so/XAlign/build/install.sh | sh

    or

    # update
    $ curl github.so/XAlign/build/update.sh | sh
   ```

### Manually

1. Download this package [XAlign.tar.gz](http://github.so/XAlign/build/XAlign.tar.gz)
2. Unpack it, copy or move the `XAlign.xcplugin` to the following path:
    ```
    ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/
    ```
    Tips: To quickly go to Finder type `Shift + Cmd + G`. If there is no `Plug-ins` directory, you should make one.

3. Restart Xcode.

## Uninstall
```
$ curl github.so/XAlign/build/uninstall.sh | sh
```

## Usage
### In Xcode
```
Xcode -> Edit -> XAlign 
```

### Auto Align Shortcut (default)
```
Shift + Cmd + X
```
You can choose the shortcut in the Settings panel, `Xcode -> Edit -> XAlign -> Setting`.


### Trouble-Shooting
  
  * [快捷键修改](https://github.com/qfish/XAlign/wiki/Trouble-Shooting#shortcut-conflicts)
   
  
## Not the end

~~I want to write more, but i am sleepy zzzzz. :)~~

TODO:

- [x] How to customize your alignment patterns
- [x] My Xcode plugin template
- [x] etc.

