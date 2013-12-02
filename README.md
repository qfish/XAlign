XAlign
======

a useful Xcode plugin to align regular code. it can align xnything with any format as u want.

## What's XAlign

there are some example format patterns below, of course, you can make your own. the example pattern file is under the `main` dir. Just try it yourself.

### 1. Align By Fisrt =
![Equal](http://github.so/XAlign/images/equal.gif)

### 2. Align By Define Group
![Equal](http://github.so/XAlign/images/define.gif)

### 3. Align By Property Group
![Equal](http://github.so/XAlign/images/property.gif)

## Install

1. Terminally

```
$ curl github.so/XAlign/build/install.sh | sh
```
2. Manually

  1. Download this package [XAlign.tar.gz](http://github.so/XAlign/build/XAlign.tar.gz)
  2. then unpackage it, copy or move the `XAlign.xcplugin` to follow path:
    ```
    ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/
    ```
    tips: Quick go in finder `cmd+shift+g`; if there's no dir `Plug-ins`, you should make one.

  3. then restart your Xcode.

## Uninstall
```
$ curl github.so/XAlign/build/uninstall.sh | sh
```

## Usage
### re in ur Xcode
```sh
Xcode -> Edit -> XAlign 
```

### Auto Align Shortcut
```sh
shfit + cmd + x
```

### Trouble-Shooting
  
  * [快捷键修改](https://github.com/qfish/XAlign/wiki/Trouble-Shooting#shortcut-conflicts)
   
  
## Not the end

I want to write more, but i am sleepy zzzzz. :)

TODO:

- [x] how to customize ur align pattern
- [x] my xcode plugin template
- [x] etc.

