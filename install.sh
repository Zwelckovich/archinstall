#!/bin/bash
#
#

## Variables
nvidia_stage=(
    linux-headers 
    nvidia-dkms 
    nvidia-settings 
    libva 
    libva-nvidia-driver-git
)

function pacman_init ()
{
    echo "#############"
    echo "#Pacman Init#"
    echo "#############"
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
    echo "#################"
    echo "#Disk Partitions#"
    echo "#################"
    fdisk -l
    echo " "
    echo "Enter disk name for installation: "
    read disk
    umount /dev/${disk}?*
    umount -l /mnt
    sgdisk --zap-all /dev/$disk
    echo "###############"
    echo "#Filesystem#"
    echo "###############"
    echo "Select Filesystem:"
    echo "  1)btrfs"
    echo "  2)ext4"

    read n
     case $n in
        1) btrfs;;
        2) ext4;;
        *) echo "invalid option";;
    esac
}

function btrfs ()
{
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

    case $n in
        1) pacstrap /mnt base linux-zen linux-firmware nano intel-ucode btrfs-progs;;
        2) pacstrap /mnt base linux -zen linux-firmware nano amd-ucode btrfs-progs;;
        3) pacstrap /mnt base linux-zen linux-firmware nano btrfs-progs;;
        *) echo "invalid option";;
    esac
    genfstab -U /mnt >> /mnt/etc/fstab
}

function ext4 ()
{
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

    echo "###############"
    echo "#Pacstrap Arch#"
    echo "###############"
    echo "Select CPU:"
    echo "  1)Intel"
    echo "  2)AMD"
    echo "  3)VMs"

    read n
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
    echo "#############"
    echo "#Base Config#"
    echo "#############"
    arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
    arch-chroot /mnt hwclock --systohc
    variable="en_US.UTF-8 UTF-8"
    arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/locale.gen
    arch-chroot /mnt locale-gen
    arch-chroot /mnt bash -c 'echo "LANG=en_US.UTF-8" >> /etc/locale.conf'
    arch-chroot /mnt bash -c 'echo "KEYMAP=de"  >> /etc/vconsole.conf'
    arch-chroot /mnt bash -c 'echo "zwelcharch" >> /etc/hostname'
    arch-chroot /mnt bash -c 'echo "127.0.0.1	localhost" >> /etc/hosts'
    arch-chroot /mnt bash -c 'echo "::1		localhost" >> /etc/hosts'
    arch-chroot /mnt bash -c 'echo "127.0.1.1	zwelcharch.localdomain	zwelcharch" >> /etc/hosts'
    echo "### ROOT PASSWORD ###"
    arch-chroot /mnt passwd
    variable="Color"
    arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/pacman.conf
    variable="ParallelDownloads = 5"
    arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/pacman.conf
    arch-chroot /mnt sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
    arch-chroot /mnt pacman-key --init
    arch-chroot /mnt pacman-key --populate archlinux
    arch-chroot /mnt pacman -Sy
    arch-chroot /mnt pacman --noconfirm -S grub grub-btrfs efibootmgr base-devel linux-zen-headers networkmanager network-manager-applet wpa_supplicant dialog os-prober mtools dosfstools reflector git ntfs-3g xdg-utils xdg-user-dirs neovim vim vi wget 
    variable="MODULES=()"
    variable_changed="MODULES=(btrfs)"
    arch-chroot /mnt sed -i "/^$variable/ c$variable_changed" /etc/mkinitcpio.conf
    arch-chroot /mnt mkinitcpio -p linux-zen
    arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id = Arch
    variable="GRUB_DISABLE_OS_PROBER=false"
    arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/default/grub
    arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
    arch-chroot /mnt useradd -mG wheel zwelch
    echo "### USER PASSWORD ###"
    arch-chroot /mnt passwd zwelch
    echo "### UNCOMMENT WHEEL GROUP ###"
    echo "### PRESS ENTER WHEN READY ###"
    read
    arch-chroot /mnt visudo
    arch-chroot /mnt systemctl enable NetworkManager
    cp -r ~/archinstall /mnt/home/zwelch
    chmod 777 /mnt/home/zwelch/archinstall
    umount -l /mnt
    echo "#################"
    echo "#SCRIPT FINISHED#"
    echo "#################"
    echo "Select Action:"
    echo "  1)Shutdown"
    echo "  2)Reboot"
    read n
    case $n in
        1) shutdown now;;
        2) reboot;;
        *) echo "invalid option";;
    esac
}

function i3_install ()
{
    echo "#################"
    echo "#I3 INSTALLATION#"
    echo "#################"
    git clone https://aur.archlinux.org/yay.git
    pushd yay
    makepkg -srci --noconfirm
    popd
    rm -rf yay
    yay --noconfirm -Sy
    yay --noconfirm -S timeshift timeshift-autosnap zramd
    sudo systemctl enable lightdm
    sudo systemctl enable --now zramd
    sudo pacman --noconfirm -Syu
    sudo pacman --noconfirm -S xorg lightdm i3 dmenu feh xfce4-terminal picom firefox pacman-contrib alsa-utils pipewire pipewire-pulse pavucontrol 
    #variable="greeter-session=example-gtk"
    #variable_changed="greeter-session=lightdm-webkit2-greeter"
    #sudo sed -i "/^#$variable*/ c$variable_changed" /etc/lightdm/lightdm.conf
    yay --noconfirm -S lightdm-webkit-theme-aether
}

function hyprland_install ()
{
    clear
    echo -ne "
    -------------------------------------------------------------------------
    ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗ 
    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗
    ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║
    ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║
    ██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝
    ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ 
    -------------------------------------------------------------------------                                                           
    "
    if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
        ISNVIDIA=true
    else
        ISNVIDIA=false
    fi

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

}

function install_software() {
    # First lets see if the package is there
    if yay -Q $1 &>> /dev/null ; then
        echo -e "$COK - $1 is already installed."
    else
        # no package found so installing
        echo -en "$CNT - Now installing $1 ."
        yay -S --noconfirm $1 &>> $INSTLOG &
        show_progress $!
        # test to make sure package installed
        if yay -Q $1 &>> /dev/null ; then
            echo -e "\e[1A\e[K$COK - $1 was installed."
        else
            # if this is hit then a package is missing, exit to review log
            echo -e "\e[1A\e[K$CER - $1 install had failed, please check the install.log"
            exit
        fi
    fi
}

echo "#####################"
echo "#Installation Script#"
echo "#####################"
echo " "
echo "Select Action:"
echo "  1)Install Arch-Base"
echo "  2)Install I3"
echo "  3)Install Hyprland"
read n
case $n in
    1) 
        pacman_init
        diskparts
        base_config
        ;;
    2) 
        i3_install
        ;;
    3)
        hyprland_install
        ;;
    *) echo "invalid option";;
esac
