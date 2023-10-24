#!/bin/bash

#   ____             __ _                       _   _             
#  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __  
# | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
# | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
#  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
#                         |___/                                   
# by John Leonard Castigo (2023)
# ------------------------------------------------------
clear
#keyboardlayout="de-latin1"
zoneinfo="Asia/Manila"
hostname="arch"
username="Leonard"

# ------------------------------------------------------
# Set System Time
# ------------------------------------------------------
ln -sf /usr/share/zoneinfo/$zoneinfo /etc/localtime
hwclock --systohc

# ------------------------------------------------------
# Update reflector
# ------------------------------------------------------
echo "Start reflector..."
#reflector -c "Germany," -p https -a 3 --sort rate --save /etc/pacman.d/mirrorlist
reflector --verbose --sort rate -c US -l 20 -f 5 --save /etc/pacman.d/mirrorlist

# ------------------------------------------------------
# Synchronize mirrors
# ------------------------------------------------------
#pacman -Syy

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
pacman --noconfirm -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools linux-headers avahi bluez bluez-utils cups bash-completion firewalld flatpak os-prober neofetch

# ------------------------------------------------------
# set lang utf8 US
# ------------------------------------------------------
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# ------------------------------------------------------
# Set Keyboard
# ------------------------------------------------------
#echo "FONT=ter-v18n" >> /etc/vconsole.conf
#echo "KEYMAP=$keyboardlayout" >> /etc/vconsole.conf

# ------------------------------------------------------
# Set hostname and localhost
# ------------------------------------------------------
echo "$hostname" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts
clear

# ------------------------------------------------------
# Set Root Password
# ------------------------------------------------------
echo "Set root password"
passwd

# ------------------------------------------------------
# Add User
# ------------------------------------------------------
echo "Add user $username"
useradd -m -g users -G wheel $username
passwd $username

# ------------------------------------------------------
# Enable Services
# ------------------------------------------------------
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable avahi-daemon
systemctl enable firewalld

# ------------------------------------------------------
# Grub installation
# ------------------------------------------------------
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=ARCH
grub-mkconfig -o /boot/grub/grub.cfg

# ------------------------------------------------------
# Adding user to wheel
# ------------------------------------------------------
clear
echo "Uncomment %wheel group in sudoers (around line 85):"
echo "Before: #%wheel ALL=(ALL:ALL) ALL"
echo "After:  %wheel ALL=(ALL:ALL) ALL"
echo ""
read -p "Open sudoers now?" c
EDITOR=vim sudo -E visudo

# ------------------------------------------------------
# Copy installation scripts to home directory 
# ------------------------------------------------------
cp /archinstall/3-yay.sh /home/$username
cp /archinstall/4-zram.sh /home/$username


# ------------------------------------------------------
# Install Arch DE(GNOME)
# ------------------------------------------------------

pacman --noconfirm -S gnome gnome-tweaks
systemctl enable gdm

clear
echo "     _                   "
echo "  __| | ___  _ __   ___  "
echo " / _' |/ _ \| '_ \ / _ \ "
echo "| (_| | (_) | | | |  __/ "
echo " \__,_|\___/|_| |_|\___| "
echo "                         "
echo ""
echo "Please find the following additional installation scripts in your home directory:"
echo "- yay AUR helper: 3-yay.sh"
echo "- zram swap: 4-zram.sh"
echo ""
echo "Please unmount exit & shutdown (umount -av shutdown -h now), remove the installation media and start again."
