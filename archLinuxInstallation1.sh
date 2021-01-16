#!/bin/bash
<<COMMENT
echo german keybordLayout
    loadkeys de 

echo connect to network
    iwctl
COMMENT
echo format disk
    dd if=/dev/zero of=/dev/sda     <<enter the partition name
    fdisk /dev/sda
        echo create 2 partition
            echo 300 MB for Kernel /dev/sda1
            echo remain for System /dev/sda2
    mkfs.ext4 /dev/sda1
    echo verschlüsselte partition
        cryptsetup -v -y --cipher aes-xts-plain64 --key-size 256 --hash sha256 --iter-time 2000 --use-urandom --verify-passphrase luksFormat /dev/sda2
    cryptsetup open /dev/sda2 SYSTEM
    mkfs.ext4 /dev/mapper/SYSTEM
echo mount
    mount /dev/mapper/SYSTEM /mnt
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot
echo install system
    pacstrap /mnt base base-devel linux linux-firmware vim wpa_supplicant netctl dialog dhcpcd grub
    genfstab -Lp /mnt > /mnt/etc/fstab
    arch-chroot /mnt
