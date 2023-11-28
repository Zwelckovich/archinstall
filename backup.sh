#!/bin/bash
#
#

# VSCode  
cp -r ~/.config/Code\ -\ OSS/User/keybindings.json ~/archinstall/dotfiles/config/Code\ -\ OSS/User/
cp -r ~/.config/Code\ -\ OSS/User/settings.json ~/archinstall/dotfiles/config/Code\ -\ OSS/User/

#  i3 
cp -r ~/.config/i3/config ~/archinstall/dotfiles/config/i3/

#  Kitty
cp -r ~/.config/kitty/kitty.conf ~/archinstall/dotfiles/config/kitty/

#  Picom
cp -r ~/.config/picom/picom.conf ~/archinstall/dotfiles/config/picom/

#  Polybar 
cp -r ~/.config/polybar/config ~/archinstall/dotfiles/config/polybar/

#  Rofi 
cp -r ~/.config/rofi/ ~/archinstall/dotfiles/config/

# SDDM
cp -r /etc/sddm.conf ~/archinstall/dotfiles/etc/
cp -r /usr/share/sddm/themes/catppuccin-mocha/ ~/archinstall/dotfiles/usr/share/sddm/themes/