#!/bin/bash

# setting up a new home system from scratch

ESSENTIAL_PACKAGES=('vim-gtk' 'git' 'stow' 'curl')
STORAGE_PACKAGES=('mergerfs' 'snapraid')
VFIO_PACKAGES=('qemu-kvm' 'qemu-utils' 'libvirt-daemon-system' \
    'libvirt-clients' 'bridge-utils' 'virt-manager' 'ovmf')
# thunar-archive-plugin & xarchiver - operations via right click context menu
# zip handling should already be installed
# p7zip-full - for 7z handling
# unar - handles rar & is free (not used by mcomix, so mcomix can't handle rar)
ARCHIVER_PACKAGES=('xarchiver' 'thunar-archive-plugin' 'unar' 'p7zip-full')
# viewnior - image viewer
MEDIA_PACKAGES=('mcomix' 'mpv' 'viewnior')
GAMING_PACKAGES=('steam')
INTERNET_PACKAGES=('filezilla')

installPackages() {
    packages=("$@")
    for package in ${packages[@]}; do
        echo "-- Installing $package --"
        sudo apt install -qqq -y $package
    done
}

echo "---- ESSENTIAL PACKAGES ----"
installPackages "${ESSENTIAL_PACKAGES[@]}"
echo "---- STORAGE PACKAGES ----"
installPackages "${STORAGE_PACKAGES[@]}"
echo "---- VFIO PACKAGES ----"
installPackages "${VFIO_PACKAGES[@]}"
echo "---- ARCHIVER PACKAGES ----"
installPackages "${ARCHIVER_PACKAGES[@]}"
echo "---- MEDIA PACKAGES ----"
installPackages "${MEDIA_PACKAGES[@]}"
echo "---- GAMING PACKAGES ----"
installPackages "${GAMING_PACKAGES[@]}"
echo "---- INTERNET PACKAGES ----"
installPackages "${INTERNET_PACKAGES[@]}"

echo "---- EXTERNAL (NON-APT) PROGRAMS ----"
YTDLP_FILE=~/.local/bin/yt-dlp
if [ ! -f "$YTDLP_FILE" ]; then
    echo "yt-dlp needs to be downloaded"
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$YTDLP_FILE"
    chmod +x "$YTDLP_FILE"
else
    echo "yt-dlp already installed"
fi

echo "---- SETUP STORAGE DIRS ----"
(cd /mnt && \
 sudo mkdir -p parity1 parity2 parity3 data data1 data2 data3 data4 data5 \
               data6 && \
 sudo chown john * && \
 echo "storage dirs setup")

echo "---- CONF ----"
# Thunar devs made showing the full path in the window title as default, it's
# terrible, and the setting to disable it isn't even configurable in UI
echo "setting show just directory name in Thunar window title"
xfconf-query --channel thunar --property /misc-full-path-in-title  --create --type bool --set false
