# vypxl's Dotfiles

 - VSCode
 - compton
 - fish / fisher
 - bspwm / sxhkd
 - neofetch
 - nvim
 - polybar
 - rofi
 - kitty

The files are managed with [yadm](https://yadm.io/)

To install, install yadm, then
```
$ yadm clone https://github.com/vypxl/dotfiles
$ yadm bootstrap # to install image, omf, ...
```

### Background Image
Url: https://www.pexels.com/de/foto/abstrakt-astrologie-astronomie-dunkel-1169754/

Just copy it as `~/.dotfiles/misc/image.png`

### VSCode
To install VSCode Settings
 - (install Shan.code-settings-sync extension) only if not already installed by `./install`
 - From Command Palette `> Sync : Advance Options > Download Settings from public Gist.`
 - Use gist id `f0648b4d9ab3b383b9874641b00efb97`

If you want to fork my settings
 - fork my https://gist.github.com/vypxl/f0648b4d9ab3b383b9874641b00efb97 gist 
 - Create a Github Gist access token
 - provide it and your gist id to the extension using `> Sync Download Settings`

### Fish
Install Oh My Fish and the bobthefish theme
```
curl -L https://get.oh-my.fish | fish
omf i bobthefish
```

### Licenses

#### i3 lock script 

https://github.com/ShikherVerma/i3lock-multimonitor
licensed under MIT License Copyright (c) 2015 Gui Meira
see /files/i3/lock for license.

#### Rofi Theme

https://github.com/DaveDavenport/rofi-themes
licensed under MIT Livense Copyright (c) 2015 Dave Davenport
see /files/rofi/material.rasi for license.
