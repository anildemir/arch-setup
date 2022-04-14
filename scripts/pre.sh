#!/bin/bash

# Connect to internet and do the partioning
# before running this script

# Example partition layout

# /mnt/boot	/dev/efi_system_partition	EFI system partition	At least 300 MiB
# [SWAP]	/dev/swap_partition	Linux swap	More than 512 MiB
# /mnt	/dev/root_partition	Linux x86-64 Remainder of the device

# # # # #

set -e

if ! [ $# -eq 3 ]; then
    echo "Please provide BOOT, SWAP and ROOT partitions."
    exit 1
fi

BOOT=$1
SWAP=$2
ROOT=$3

# Some checks

if ! [ -d /sys/firmware/efi ]
then
  echo "ERROR: System is not booted as UEFI.";
  exit 1;
fi

if ! ping -q -c 1 -W 1 archlinux.org >/dev/null; then
  echo "ERROR: No internet connection.";
  exit 1;
fi

# Time

timedatectl set-ntp true

mkfs.fat -F 32 $BOOT
mkswap $SWAP
swapon $SWAP
mkfs.ext4 $ROOT

e2label $ROOT arch_os

mount $ROOT /mnt
mount --mkdir $BOOT /mnt/boot

pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab