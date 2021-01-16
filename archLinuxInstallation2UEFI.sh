#!/bin/bash
echo enter and customize system
    echo hostName > /etc/hostname
    echo LANG=de_DE.UTF-8 > /etc/locale.conf
    vim /etc/locale.gen
    sleep 2
    locale-gen
    sleep 2
    echo because the system is crypeted - add HOOK between block and filesystem: encrypt
    sleep 2
    vim /etc/mkinitcpio.conf
    sleep 2
    mkinitcpio -P
    echo KEYMAP=de-latin1 > /etc/vconsole.conf
    sleep 2
    ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
    sleep 2
    hwclock --systohc
    echo add multilib
    sleep 2
    vim /etc/pacman.conf
    sleep 2
    passwd
    echo for UEFI installation
    sleep 2
    pacman -Sy efibootmgr dosfstools gptfdisk
    sleep 2
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=archGrub --recheck
    echo add GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:SYSTEM root=/dev/mapper/SYSTEM"
    vim /etc/default/grub
    sleep 2
    grub-mkconfig -o /boot/grub/grub.cfg
echo end
