#!/bin/bash
clear
echo "    _             _       ___           _        _ _ "
echo "   / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | |"
echo "  / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _' | | |"
echo " / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | |"
echo "/_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_|"
echo ""
echo "by John Leonard Castigo (2023)"
echo "-----------------------------------------------------"
echo ""
echo "Important: Please make sure that you have followed the "
echo "manual steps in the README to partition the harddisc!"
echo "Warning: Run this script at your own risk."
echo ""

# ------------------------------------------------------
# Enter partition names
# ------------------------------------------------------
lsblk
read -p "Enter the name of the EFI partition (eg. sda1): " efipartition
read -p "Enter the name of the ROOT partition (eg. sda2): " rootpartition
# read -p "Enter the name of the VM partition (keep it empty if not required): " sda3

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
timedatectl set-ntp true

# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
mkfs.fat -F32 /dev/$efipartition
mkfs.btrfs -f /dev/$rootpartition
# mkfs.btrfs -f /dev/$sda3

# ------------------------------------------------------
# Mount points for btrfs
# ------------------------------------------------------
mount /dev/$rootpartition /mnt
cd /mnt
btrfs  subvolume create @
btrfs  subvolume create @home
btrfs  subvolume create @log
btrfs  subvolume create @pkg
btrfs  subvolume create @snapshots
cd
umount /mnt

mount -o noatime,compress=zstd,subvol=@ /dev/$rootpartition /mnt

mkdir -p /mnt/home
mkdir -p /mnt/var/log
mkdir -p /mnt/var/cache/pacman/pkg
mkdir -p /mnt/.snapshots
mkdir -p /mnt/efi

#mounting root and its subvolume
mount -o noatime,compress=zstd,subvol=@home /dev/$rootpartition /mnt/home
mount -o noatime,compress=zstd,subvol=@log /dev/$rootpartition /mnt/var/log
mount -o noatime,compress=zstd,subvol=@pkg /dev/$rootpartition /mnt/var/cache/pacman/pkg
mount -o noatime,compress=zstd,subvol=@snapshots /dev/$rootpartition /mnt/.snapshots
#mounting efi
mount /dev/$efipartition /mnt/efi

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
pacstrap /mnt base base-devel git linux linux-firmware vim openssh reflector amd-ucode

# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab
#cat /mnt/etc/fstab

# ------------------------------------------------------
# Install configuration scripts
# ------------------------------------------------------
mkdir /mnt/archinstall
cd
cd ArchInstall
chmod +x 2-configuration.sh
cp 2-configuration.sh /mnt/archinstall/
cp 3-yay.sh /mnt/archinstall/
cp 4-zram.sh /mnt/archinstall/

# ------------------------------------------------------
# Chroot to installed sytem
# ------------------------------------------------------
arch-chroot /mnt ./archinstall/2-configuration.sh