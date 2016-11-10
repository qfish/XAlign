XAlign (Ready for Xcode 8+ 🚀)
======

An amazing Xcode plugin to align regular code. It can align anything by using custom alignment patterns.

## What's XAlign

Here are some example alignment patterns. Of course you can make your own. The pattern file is here:  `/Source/Patterns.bundle/default.plist`, and the patterns are based on regular expression.

**Tips**: 

   * _You may not like the alignment style below, **try it yourself** or **tell me at the [Issues](https://github.com/qfish/XAlign/issues?state=open)**._ :)
   * There is no need to align all codes at a time when they are complicated, try to align by group which the codes are more similar in.
   * 对齐不需要一次全部对齐，可以分组多对几次，那些等号差的太远的就别让它参与对齐了。
   * 默认对齐的风格不是你喜欢的，可以自定义，或者提个 [Issues](https://github.com/qfish/XAlign/issues?state=open)。

### Align by equals sign
![Equal](http://qfi.sh/XAlign/images/equal.gif)

### Align by define group
![Define](http://qfi.sh/XAlign/images/define.gif)

### Align by property group
![Property](http://qfi.sh/XAlign/images/property.gif)

### Todo:

- [x] Much easier to customize alignment patterns.

## Install on Xcode 8
1. Download the [XAlign.dmg 📎](https://github.com/qfish/XAlign/releases/download/untagged-37425b5c3153fd315072/XAlign.1.0.dmg)
2. Open and copy `XAlign.app` to `/Applications` folder
3. Run it then close it.

## Usage
### 1. Enable XAlign
Check <kbd>System Preferences</kbd> -> <kbd>Extensions</kbd> -> <kbd>Xocde Source Editor</kbd> -> <kbd>XAlign</kbd>

   ![help-1](https://cloud.githubusercontent.com/assets/679824/20145614/b86f6742-a6db-11e6-846b-771447ec0933.png)

### 2. Setting Shortcut in Xocde 
<kbd>Preferences</kbd> -> <kbd>Key bindings</kbd> -> <kbd>Filter: xalign</kbd>

   ![help-2](https://cloud.githubusercontent.com/assets/679824/20146079/735244ca-a6dd-11e6-83a9-069fd489b0f6.png)

## Trouble Shooting
* Please `run sudo /usr/libexec/xpccachectl` and **restart your Mac** before running the extension if you are on macOS 10.11 El Capitan.
* If you are looking for the version supporting Xcode 7, check this branch;

## Want to help
  
  * [Star this repository](https://github.com/qfish/XAlign/)
  * [Bugs Report & Advice](https://github.com/qfish/XAlign/issues)
  * [Fork & Pull Request](https://github.com/qfish/XAlign/pulls)

## Special thanks to

* <img src="http://geek-zoo.com/img/logo-dark.png" alt="Geek Zoo Studio" height="20px" />  <a href="http://www.geek-zoo.com" target="_blank">Geek Zoo Studio</a>

  They provide awesome design and development works continues to help the open-source community even better.


* [BeeFramework](https://github.com/gavinkwoe/BeeFramework) 

  BeeFramework is a new generation of development framework which makes faster and easier app development, Build your app by geek's way.
