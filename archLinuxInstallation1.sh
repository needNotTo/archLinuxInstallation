#!/bin/bash
<<COMMENT
echo german keybordLayout
    loadkeys de 

echo connect to network
    iwctl
    dd if=/dev/zero of=/dev/sda     <<enter the partition name
COMMENT
echo format disk
        echo create 2 partition
            echo 300 MB for Kernel /dev/sda1
            echo remain for System /dev/sda2
	    sleep 2
    fdisk /dev/sda
    sleep 2
    mkfs.ext4 /dev/sda1
    echo verschlüsselte partition
    sleep 2
        cryptsetup -v -y --cipher aes-xts-plain64 --key-size 256 --hash sha256 --iter-time 2000 --use-urandom --verify-passphrase luksFormat /dev/sda2
    sleep 2
    cryptsetup open /dev/sda2 SYSTEM
    sleep 2
    mkfs.ext4 /dev/mapper/SYSTEM
echo mount
    sleep 2
    mount /dev/mapper/SYSTEM /mnt
    sleep 2
    mkdir /mnt/boot
    sleep 2
    mount /dev/sda1 /mnt/boot
    sleep 2
echo install system
    sleep 2
    pacstrap /mnt base base-devel linux linux-firmware vim wpa_supplicant netctl dialog dhcpcd grub
    sleep 2
    genfstab -Lp /mnt > /mnt/etc/fstab
    sleep 2
    arch-chroot /mnt
