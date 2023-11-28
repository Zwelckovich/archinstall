#!/bin/bash
#
#

function backup()
{
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

    # Thorium
    tar cf - ~/.config/thorium -P | pv -s $(du -sb ~/.config/thorium | awk '{print $1}') | gzip > ~/archinstall/thorium-profile.tar.gz
    gpg -c ~/archinstall/thorium-profile.tar.gz
    rm -rf ~/archinstall/thorium-profile.tar.gz

    # Fish
    cp -r ~/.config/fish/config.fish ~/archinstall/dotfiles/config/fish/
}

function restore()
{
    # All Configs
    cp -r ~/archinstall/dotfiles/config/* ~/.config/

    # SDDM
    sudo cp -r ~/archinstall/dotfiles/etc/sddm.conf /etc/
    sudo cp -r ~/archinstall/dotfiles/usr/share/sddm/themes/catppuccin-mocha/ /usr/share/sddm/themes/
    gpg ~/archinstall/thorium-profile.tar.gz.gpg
    pv ~/archinstall/thorium-profile.tar.gz | tar -xzf - -C ~/.config/
    rm -rf ~/archinstall/thorium-profile.tar.gz
}


clear
echo -ne "
-------------------------------------------------------------------------------------------------
██████╗  █████╗  ██████╗██╗  ██╗██╗   ██╗██████╗     ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗
██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██║   ██║██╔══██╗    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝
██████╔╝███████║██║     █████╔╝ ██║   ██║██████╔╝    ███████╗██║     ██████╔╝██║██████╔╝   ██║   
██╔══██╗██╔══██║██║     ██╔═██╗ ██║   ██║██╔═══╝     ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   
██████╔╝██║  ██║╚██████╗██║  ██╗╚██████╔╝██║         ███████║╚██████╗██║  ██║██║██║        ██║   
╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝         ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   
-------------------------------------------------------------------------------------------------
"     
echo ""
echo "Select Action:"
echo "  1)BACKUP"
echo "  2)RESTORE"
read n
case $n in
    1) 
        backup
        ;;
    2) 
        restore
        ;;
    *) echo "invalid option";;
esac