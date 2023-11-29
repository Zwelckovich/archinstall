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

    # SDDM
    sudo cp -r ~/archinstall/dotfiles/etc/sddm.conf /etc/
    sudo cp -r ~/archinstall/dotfiles/usr/share/sddm/themes/catppuccin-mocha/ /usr/share/sddm/themes/

    # Scripts
    cp -r ~/archinstall/dotfiles/scripts/ ~/

    # Grub
    sudo cp -r ~/archinstall/dotfiles/etc/default/grub /etc/default/ 
    sudo cp -r ~/archinstall/dotfiles/usr/share/grub/themes/* /usr/share/grub/themes/
    sudo grub-mkconfig -o /boot/grub/grub.cfg
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
restore
