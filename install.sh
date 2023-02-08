#!/bin/bash
#
#

## Variables

function pacman_init ()
{
    echo "#############"
    echo "#Pacman Init#"
    echo "#############"
    pacman-key --init   
    pacman-key --populate archlinux
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
}

function pacstrap_arch ()
{
    echo "###############"
    echo "#Pacstrap Arch#"
    echo "###############"
    echo "Select CPU:"
    echo "  1)Intel"
    echo "  2)AMD"
    echo "  3)VMs"

    read n
    case $n in
      1) pacstrap /mnt base linux-zen linux-firmware nano intel-ucode btrfs-progs;;
      2) pacstrap /mnt base linux -zen linux-firmware nano amd-ucode btrfs-progs;;
      3) pacstrap /mnt base linux-zen linux-firmware nano btrfs-progs;;
      *) echo "invalid option";;
    esac
    genfstab -U /mnt >> /mnt/etc/fstab
    arch-chroot /mnt
}

function base_config ()
{
    ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
    hwclock --systohc
    variable="en_US.UTF-8 UTF-8"; sed -i "/^#$variable/ c$variable" /etc/locale.gen
}


echo "####################"
echo "#Installtion Script#"
echo "####################"
echo " "
echo "Press enter to start..."
read
## Sequencer
pacman_init
diskparts
pacstrap_arch
base_config
