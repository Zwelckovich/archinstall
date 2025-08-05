#!/bin/bash

# Variables
#

wallpaper=$HOME/.config/hypr/wallpaper_effects/.wallpaper_modified

swww-daemon &
# swww img ~/.config/hypr/wallpaper/.wallpaper_current --transition-bezier .43,1.19,1,.4 --transition-fps 30 --transition-type grow --transition-pos 0.925,0.977 --transition-duration 2
swww img ~/archinstall/wallpaper/bonsai_back_2k_dark.png --transition-bezier .43,1.19,1,.4 --transition-fps 30 --transition-type grow --transition-pos 0.925,0.977 --transition-duration 2
