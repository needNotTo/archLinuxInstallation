#!/bin/bash
echo enter and customize system
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
    echo for UEFI installation
    pacman -Sy efibootmgr dosfstools gptfdisk
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=archGrub --recheck
    echo add GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:SYSTEM root=/dev/mapper/SYSTEM"
    vim /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
echo end
