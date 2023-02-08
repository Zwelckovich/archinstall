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
    echo "Enter disk name for installation: "
    read disk
    sgdisk --zap-all /dev/$disk
    sgdisk -n 1:0:+300M -n 2:0:+8G -n 3:0:0 -t 1:ef00 -t 2:8200 /dev/$disk -p
    dn=${disk}1
    mkfs.fat -F32 /dev/$dn
    dn=${disk}2
    mkswap /dev/$dn
    swapon /dev/$dn
    dn=${disk}3
    mkfs.btrfs /dev/$dn
    mount /dev/$dn /mnt
    cd /mnt
    read
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
