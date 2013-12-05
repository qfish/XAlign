XAlign
======

An amazing Xcode plugin to align regular code. It can align anything by using custom alignment patterns.

## What's XAlign

Here are some example alignment patterns. Of course you can make your own. The pattern file is here:  `main/main/patterns.plist`, the patterns are based on regular expression. Just try it yourself.

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

## Trouble-Shooting
  
  * [wiki](https://github.com/qfish/XAlign/wiki)
   
## Want to help
  
  * [Star this repository](https://github.com/qfish/XAlign/)
  * [Bugs Report & Advice](https://github.com/qfish/XAlign/issues)
  * [Fork & Pull Request](https://github.com/qfish/XAlign/pulls)

## Special thanks to

* [![Geek-Zoo](http://geek-zoo.com/images/logo-01.png)](http://www.geek-zoo.com)

  They provide awesome design and development works continues to help the open-source community even better.


* [BeeFramework](https://github.com/gavinkwoe/BeeFramework) 

  BeeFramework is a new generation of development framework which makes faster and easier app development, Build your app by geek's way.

### Todo:

- [x] How to customize your alignment patterns
- [x] My Xcode plugin template
- [x] etc.

