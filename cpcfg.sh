#!/bin/bash
#
#

function restore()
{
    if ls -la ~/ | grep -iqE git-crypt-key; then
        echo -e "Using git-crypt-key"
        # Uncrypt
        pushd  ~/archinstall/
        git-crypt unlock ../git-crypt-key
        popd

        # Secrets
        cp -r ~/archinstall/secrets/config/* ~/.config/
        cp -r ~/archinstall/secrets/home/. ~/
    else
        echo -e "No git-crypt-key. Skipping secrets"
    fi

    # Check VSCode Extensions
    if code --list-extensions | grep -iE catppuccin  &>> /dev/null; then
        echo -e "VSCode Catppuccin Extensions is already installed."
    else
        echo -e "Installing Catppuccin VSCode Extensions"
        code --install-extension Catppuccin.catppuccin-vsc
        code --install-extension Catppuccin.catppuccin-vsc-icons
    fi


    # All Configs
    cp -r ~/archinstall/dotfiles/config/* ~/.config/

    # VM Settings
    echo -e "$CNT - Checking for Physical or VM..."
    ISVM=$(hostnamectl | grep Chassis)
    # echo -e "Using $ISVM"
    if [[ $ISVM == *"vm"* ]]; then
        echo -e "Using VM Picom Conf..."
    else
        echo -e "Using GLX Picom Conf..."
        variable='# backend = "glx";'
        variable_new='backend = "glx";'
        sed -i "s/$variable/$variable_new/" ~/.config/picom/picom.conf
        sleep 1
    fi

    # SDDM
    sudo cp -r ~/archinstall/dotfiles/etc/sddm.conf /etc/
    sudo cp -r ~/archinstall/dotfiles/usr/share/sddm/themes/catppuccin-mocha/ /usr/share/sddm/themes/

    # Scripts
    cp -r ~/archinstall/dotfiles/scripts/ ~/

}

function update_grub()
{
    # Grub
    sudo cp -r ~/archinstall/dotfiles/etc/default/grub /etc/default/ 
    sudo cp -r ~/archinstall/dotfiles/usr/share/grub/themes/* /usr/share/grub/themes/
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

function citrix()
{
   # Citrix
   yay -Sy icaclient
   cp -r ~/archinstall/dotfiles/home/.ICAClient ~/
   sudo cp -r ~/archinstall/dotfiles/usr/bin/pulseaudio /usr/bin/
   sudo cp -r ~/archinstall/dotfiles/usr/share/applications/wfica.desktop /usr/share/applications/
   sudo ln -s /usr/lib/libunwind.so /usr/lib/libunwind.so.1
   # https://wiki.archlinux.org/title/citrix
}
clear
echo -ne "
-----------------------------------------
 ██████╗██████╗  ██████╗███████╗ ██████╗ 
██╔════╝██╔══██╗██╔════╝██╔════╝██╔════╝ 
██║     ██████╔╝██║     █████╗  ██║  ███╗
██║     ██╔═══╝ ██║     ██╔══╝  ██║   ██║
╚██████╗██║     ╚██████╗██║     ╚██████╔╝
 ╚═════╝╚═╝      ╚═════╝╚═╝      ╚═════╝ 
                                         
-----------------------------------------
"     
echo ""
echo "Select Action:"
echo "  1)Restore Configs"
echo "  2)Update Grub"
echo "  3)Install Citrix"
read -p 'Selection: ' n
case $n in
    1) 
        restore
        ;;
    2) 
        update_grub
        ;;
    3)
        citrix
        ;;
    *) echo "invalid option";;
esac
