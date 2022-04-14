#!/bin/bash

set -e

ln -sf /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
hwclock --systohc
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'KEYMAP=us' > /etc/vconsole.conf
echo 'testhostname' > /etc/hostname
mkinitcpio -P
# passwd

if ! [ -d /sys/firmware/efi ]
then
  echo "ERROR: System is not booted as UEFI.";
  exit 1;
fi

bootctl install

echo 'default arch.conf' >> /boot/loader/loader.conf
echo 'timeout 4' >> /boot/loader/loader.conf
echo 'console-mode max' >> /boot/loader/loader.conf
echo 'editor no' >> /boot/loader/loader.conf

echo 'title Arch Linux' >> /boot/loader/entries/arch.conf
echo 'linux /vmlinuz-linux' >> /boot/loader/entries/arch.conf
echo 'initrd /intel-ucode.img' >> /boot/loader/entries/arch.conf
echo 'initrd /initramfs-linux.img' >> /boot/loader/entries/arch.conf
echo 'options root="LABEL=arch_os" rw' >> /boot/loader/entries/arch.conf

echo 'title Arch Linux (fallback initramfs)' >> /boot/loader/entries/arch-fallback.conf
echo 'linux /vmlinuz-linux' >> /boot/loader/entries/arch-fallback.conf
echo 'initrd /intel-ucode.img' >> /boot/loader/entries/arch-fallback.conf
echo 'initrd /initramfs-linux-fallback.img' >> /boot/loader/entries/arch-fallback.conf
echo 'options root="LABEL=arch_os" rw' >> /boot/loader/entries/arch-fallback.conf

echo 'Installation done.'