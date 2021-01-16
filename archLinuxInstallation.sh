#!/bin/bash
echo german keybordLayout
    loadkeys de 

echo connect to network
    iwctl
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
echo enter and customize system
    arch-chroot /mnt
    echo hostName > /etc/hostname
    echo LANG=de_DE.UTF-8 > /etc/locale.conf
    vim /etc/locale.gen
    locale-gen
    echo because the system is crypeted - add HOOK between block and filesystem: encrypt
    vim /etc/mkinitcpio.conf
    mkinitcpio -P
    echo KEYMAP=de-latin1 > /etc/vconsole.conf
    ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
    hwclock --systohc
    echo add multilib
    vim /etc/pacman.conf
    passwd
    echo for BIOS installation
    grub-install --target=i386-pc /dev/sda
    echo add GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:SYSTEM root=/dev/mapper/SYSTEM"
    vim /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
echo end
    exit
    umount -R /mnt
    cryptsetup close SYSTEM
