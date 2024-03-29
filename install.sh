#!/bin/bash
#
#

## Variables
i3_base_stage=(
    xorg
    i3
    sddm
    rofi
    feh
    xfce4-terminal
    picom
    thorium-browser-bin
    pacman-contrib 
    alsa-utils
    pipewire 
    pipewire-pulse
    pavucontrol
    ttf-noto-nerd
    noto-fonts-emoji
    kitty
    code
    numlockx
    qt5-graphicaleffects
    qt5-svg
    qt5-quickcontrols2
    polybar
    fish
    eza
    neofetch
    starship
    npm
    bfg
    i3lock-color
    spotify-tui
    spotifyd
    git-crypt
    zathura
    zathura-pdf-mupdf
    btop
    lazygit
    icaclient
    python-conda
    qucs-s
    inkscape
)

#software for nvidia GPU only
nvidia_stage=(
    linux-headers 
    nvidia-dkms 
    nvidia-settings 
    libva 
    libva-nvidia-driver-git
)

# set some colors
CNT="[\e[1;36mNOTE\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"
INSTLOG="install.log"


function pacman_init ()
{
    clear
    echo -ne "
    ---------------------------------------------------------------------
     █████╗ ██████╗  ██████╗██╗  ██╗    ██████╗  █████╗ ███████╗███████╗
    ██╔══██╗██╔══██╗██╔════╝██║  ██║    ██╔══██╗██╔══██╗██╔════╝██╔════╝
    ███████║██████╔╝██║     ███████║    ██████╔╝███████║███████╗█████╗  
    ██╔══██║██╔══██╗██║     ██╔══██║    ██╔══██╗██╔══██║╚════██║██╔══╝  
    ██║  ██║██║  ██║╚██████╗██║  ██║    ██████╔╝██║  ██║███████║███████╗
    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝
                                                                        
    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗                   
    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║                   
    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║                   
    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║                   
    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗              
    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝                                                                   
    ---------------------------------------------------------------------
    "
    echo ""
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                               Pacman Init                                                        "
    echo "------------------------------------------------------------------------------------------------------------------"
    pacman-key --init   
    pacman-key --populate archlinux
    variable="Color"
    sed -i "/^#$variable/ c$variable" /etc/pacman.conf
    variable="ParallelDownloads = 5"
    sed -i "/^#$variable/ c$variable" /etc/pacman.conf
    sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
}

function diskparts ()
{
    clear
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                               File System                                                        "
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "Select Filesystem:"
    echo "  1)btrfs"
    echo "  2)ext4"

    read n
     case $n in
        1) btrfs_format;;
        2) ext4_format;;
        *) echo "invalid option";;
    esac
}

function btrfs_format ()
{
    clear
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                               Disk Partitions                                                    "
    echo "------------------------------------------------------------------------------------------------------------------"
    fdisk -l
    echo " "
    read -p 'Enter disk name for installation: ' disk
    umount /dev/${disk}?*
    umount -l /mnt
    sgdisk --zap-all /dev/$disk
    sgdisk -n 1:0:+300M -n 2:0:+8G -n 3:0:0 -t 1:ef00 -t 2:8200 /dev/$disk -p
    dn=${disk}1
    mkfs.fat -F32 /dev/$dn
    dn=${disk}2
    swapoff /dev/$dn
    mkswap /dev/$dn
    swapon /dev/$dn
    dn=${disk}3 
    mkfs.btrfs -f /dev/$dn
    mount /dev/$dn /mnt
    btrfs su cr /mnt/@
    btrfs su cr /mnt/@home
    btrfs su cr /mnt/@var
    btrfs su cr /mnt/@opt
    btrfs su cr /mnt/@tmp
    btrfs su cr /mnt/@.snapshots
    umount /mnt
    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ /dev/$dn /mnt
    mkdir /mnt/{boot,home,var,opt,tmp,.snapshots}
    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home /dev/$dn /mnt/home
    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@var /dev/$dn /mnt/var
    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@opt /dev/$dn /mnt/opt
    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@tmp /dev/$dn /mnt/tmp
    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@.snapshots /dev/$dn /mnt/.snapshots
    dn=${disk}1
    mount /dev/$dn /mnt/boot

    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                                Pacstrap Arch                                                     "
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "Select CPU:"
    echo "  1)Intel"
    echo "  2)AMD"
    echo "  3)VMs"

    read -p 'Selection: ' n
    case $n in
        1) pacstrap /mnt base linux-zen linux-firmware nano intel-ucode btrfs-progs;;
        2) pacstrap /mnt base linux -zen linux-firmware nano amd-ucode btrfs-progs;;
        3) pacstrap /mnt base linux-zen linux-firmware nano btrfs-progs;;
        *) echo "invalid option";;
    esac
    genfstab -U /mnt >> /mnt/etc/fstab
}

function ext4_format ()
{
    clear
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                               Disk Partitions                                                    "
    echo "------------------------------------------------------------------------------------------------------------------"
    fdisk -l
    echo " "
    read -p 'Enter disk name for installation: ' disk
    umount /dev/${disk}?*
    umount -l /mnt
    sgdisk --zap-all /dev/$disk
    sgdisk -n 1:0:+300M -n 2:0:+8G -n 3:0:0 -t 1:ef00 -t 2:8200 /dev/$disk -p
    dn=${disk}1
    mkfs.fat -F32 /dev/$dn
    dn=${disk}2
    swapoff /dev/$dn
    mkswap /dev/$dn
    swapon /dev/$dn
    dn=${disk}3 
    mkfs.ext4 /dev/$dn
    mount /dev/$dn /mnt
    mkdir /mnt/boot
    dn=${disk}1
    mount /dev/$dn /mnt/boot

    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                                Pacstrap Arch                                                     "
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "Select CPU:"
    echo "  1)Intel"
    echo "  2)AMD"
    echo "  3)VMs"

    read -p 'Selection: ' n
    case $n in
        1) pacstrap /mnt base linux-zen linux-firmware nano intel-ucode;;
        2) pacstrap /mnt base linux -zen linux-firmware nano amd-ucode;;
        3) pacstrap /mnt base linux-zen linux-firmware nano;;
        *) echo "invalid option";;
    esac
    genfstab -U /mnt >> /mnt/etc/fstab
}

function base_config ()
{
    clear
    echo -ne "
    ---------------------------------------------------------------------
     █████╗ ██████╗  ██████╗██╗  ██╗    ██████╗  █████╗ ███████╗███████╗
    ██╔══██╗██╔══██╗██╔════╝██║  ██║    ██╔══██╗██╔══██╗██╔════╝██╔════╝
    ███████║██████╔╝██║     ███████║    ██████╔╝███████║███████╗█████╗  
    ██╔══██║██╔══██╗██║     ██╔══██║    ██╔══██╗██╔══██║╚════██║██╔══╝  
    ██║  ██║██║  ██║╚██████╗██║  ██║    ██████╔╝██║  ██║███████║███████╗
    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝
                                                                        
    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗                   
    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║                   
    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║                   
    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║                   
    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗              
    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝              
                                                                    
    ---------------------------------------------------------------------
    "     
    echo ""
    read -p 'Enter username: ' userstr
    read -p "Enter hostname: " hoststr
    arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
    arch-chroot /mnt hwclock --systohc
    variable="en_US.UTF-8 UTF-8"
    arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/locale.gen
    arch-chroot /mnt locale-gen
    arch-chroot /mnt bash -c "echo \"LANG=en_US.UTF-8\" >> /etc/locale.conf"
    arch-chroot /mnt bash -c "echo \"KEYMAP=de-latin1-nodeadkeys\"  >> /etc/vconsole.conf"
    cmdstr="echo \"$hoststr\" >> /etc/hostname"
    arch-chroot /mnt bash -c "$cmdstr"
    arch-chroot /mnt bash -c "echo \"127.0.0.1	localhost\" >> /etc/hosts"
    arch-chroot /mnt bash -c "echo \"::1		localhost\" >> /etc/hosts"
    cmdstr="echo \"127.0.1.1	$hoststr.localdomain	$hoststr\" >> /etc/hosts"
    arch-chroot /mnt bash -c "$cmdstr"
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                               Root Password                                                      "
    echo "------------------------------------------------------------------------------------------------------------------"
    arch-chroot /mnt passwd
    variable="Color"
    arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/pacman.conf
    variable="ParallelDownloads = 5"
    arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/pacman.conf
    arch-chroot /mnt sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
    arch-chroot /mnt pacman-key --init
    arch-chroot /mnt pacman-key --populate archlinux
    arch-chroot /mnt pacman -Sy
    arch-chroot /mnt pacman --noconfirm -S grub grub-btrfs efibootmgr base-devel linux-zen-headers networkmanager network-manager-applet wpa_supplicant dialog os-prober mtools dosfstools reflector git ntfs-3g xdg-utils xdg-user-dirs neovim vim vi wget iwd 
    variable="MODULES=()"
    variable_changed="MODULES=(btrfs)"
    arch-chroot /mnt sed -i "/^$variable/ c$variable_changed" /etc/mkinitcpio.conf
    arch-chroot /mnt mkinitcpio -p linux-zen
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id = Arch
    variable="GRUB_DISABLE_OS_PROBER=false"
    arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/default/grub
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
    arch-chroot /mnt useradd -mG wheel $userstr
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                               User Password                                                      "
    echo "------------------------------------------------------------------------------------------------------------------"
    arch-chroot /mnt passwd $userstr
    variable="%wheel ALL=(ALL:ALL) ALL"
    arch-chroot /mnt sed -i "/^# $variable/s/#\s*//" /etc/sudoers
    arch-chroot /mnt systemctl enable NetworkManager
    cp -r ~/archinstall /mnt/home/$userstr
    chmod 777 /mnt/home/$userstr/archinstall
    umount -l /mnt
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "                                                SCRIPT FINISHED                                                   "
    echo "------------------------------------------------------------------------------------------------------------------"
    echo "Select Action:"
    echo "  1)Shutdown"
    echo "  2)Reboot"
    read -p 'Selection: ' n
    case $n in
        1) shutdown now;;
        2) reboot;;
        *) echo "invalid option";;
    esac
}

function i3_install ()
{
    clear
    echo -ne "
    ---------------------------------------------------------------------
    ██╗██████╗     ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     
    ██║╚════██╗    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     
    ██║ █████╔╝    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     
    ██║ ╚═══██╗    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     
    ██║██████╔╝    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
    ╚═╝╚═════╝     ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
    ---------------------------------------------------------------------
    "     
    echo ""
    if ! command -v yay &> /dev/null
    then
        echo "yay could not be found"
        git clone https://aur.archlinux.org/yay.git
        pushd yay
        makepkg -srci --noconfirm
        popd
        rm -rf yay
    fi
    yay --noconfirm -Sy
     # find the Nvidia GPU
    if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
        ISNVIDIA=true
    else
        ISNVIDIA=false
    fi
      # Setup Nvidia if it was found
    if [[ "$ISNVIDIA" == true ]]; then
        echo -e "$CNT - Nvidia GPU support setup stage, this may take a while..."
        for SOFTWR in ${nvidia_stage[@]}; do
            install_software $SOFTWR
        done
    
        # update config
        sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
        sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
        echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf &>> $INSTLOG
    fi
    for SOFTWR in ${i3_base_stage[@]}; do
            install_software $SOFTWR
    done 
    sudo systemctl enable sddm
    sh ~/archinstall/cpcfg.sh
}


show_progress() {
    while ps | grep $1 &> /dev/null;
    do
        echo -n "."
        sleep 2
    done
    echo -en "Done!\n"
    sleep 2
}

function install_software() {
    # no package found so installing
    echo -en "$CNT - Now installing $1 ."
    yay -S --noconfirm $1 &>> $INSTLOG &
    show_progress $!
    # test to make sure package installed
    echo -e "\e[1A\e[K$COK - $1 was installed."
}

clear
echo -ne "
--------------------------------------------------------------------------------------
 █████╗ ██████╗  ██████╗██╗  ██╗██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     
██╔══██╗██╔══██╗██╔════╝██║  ██║██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     
███████║██████╔╝██║     ███████║██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     
██╔══██║██╔══██╗██║     ██╔══██║██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     
██║  ██║██║  ██║╚██████╗██║  ██║██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
                                                                                      
---------------------------------------------------------------------------------------
"     
echo ""
echo "Select Action:"
echo "  1)Install Arch Minimal"
echo "  2)Install i3"
read -p 'Selection: ' n
case $n in
    1) 
        pacman_init
        diskparts
        base_config
        ;;
    2) 
        i3_install
        ;;
    *) echo "invalid option";;
esac
