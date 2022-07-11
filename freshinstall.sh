#!/bin/bash

# setting up a new home system from scratch

ESSENTIAL_PACKAGES=('vim-gtk' 'git' 'stow' 'curl')
STORAGE_PACKAGES=('mergerfs' 'snapraid' 'gparted')
# dkms is needed to install vendor-reset modules
VFIO_PACKAGES=('qemu-kvm' 'qemu-utils' 'libvirt-daemon-system' \
    'libvirt-clients' 'bridge-utils' 'virt-manager' 'ovmf' 'dkms' 'samba')
# thunar-archive-plugin & xarchiver - operations via right click context menu
# xarchiver unfortunately prefer p7zip over unar for dealing with rar files, so
# we have to decompress rar files with command line unar
# p7zip-full - for 7z handling
# unar - unfortunately, while unar has a free implementation of rar extract,
#        it is unable to handle newer rar compressions
# p7zip-rar - non-free, but can handle newer rar compressions
ARCHIVER_PACKAGES=('xarchiver' 'thunar-archive-plugin' 'p7zip-full' 'p7zip-rar')
# viewnior - image viewer
# evince - pdf viewer
MEDIA_PACKAGES=('gimp' 'mcomix' 'mpv' 'viewnior' 'evince' 'mkvtoolnix')
CAD_PACKAGES=('freecad' 'openscad')
GAMING_PACKAGES=('steam')
INTERNET_PACKAGES=('filezilla')
# hddtemp gets pulled in but needs workaround: sudo chmod +s /usr/sbin/hddtemp
SENSOR_PACKAGES=('xfce4-sensors-plugin' 'xfce4-systemload-plugin' 'xfce4-netload-plugin' 'xsensors' 'smartmontools')
TOOL_PACKAGES=('byobu' 'aptitude')

# Manual
# NoiseTorch - real-time microphone noise suppression
# Firefox - get rid of snap
# Samba - copy smb.conf
# setup samba share user password
# sudo smbpasswd -a john

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
echo "---- CAD PACKAGES ----"
installPackages "${CAD_PACKAGES[@]}"
echo "---- GAMING PACKAGES ----"
installPackages "${GAMING_PACKAGES[@]}"
echo "---- INTERNET PACKAGES ----"
installPackages "${INTERNET_PACKAGES[@]}"
echo "---- SENSOR PACKAGES ----"
installPackages "${SENSOR_PACKAGES[@]}"
echo "---- TOOL PACKAGES ----"
installPackages "${TOOL_PACKAGES[@]}"

echo "---- EXTERNAL (NON-APT) PROGRAMS ----"
# need to ensure local bin exists first
mkdir -p ~/.local/bin/
YTDLP_FILE=~/.local/bin/yt-dlp
if [ ! -f "$YTDLP_FILE" ]; then
    echo "yt-dlp needs to be downloaded"
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$YTDLP_FILE"
    chmod +x "$YTDLP_FILE"
else
    echo "yt-dlp already installed"
fi

# TODO: add install btop, prusaslicer

echo "---- SETUP STORAGE DIRS ----"
(cd /mnt && \
 sudo mkdir -p parity1 parity2 parity3 data data1 data2 data3 data4 data5 \
               data6 data7 && \
 sudo chown john * && \
 echo "storage dirs setup")

echo "---- CONF ----"
# Thunar devs made showing the full path in the window title as default, it's
# terrible, and the setting to disable it isn't even configurable in UI
echo "setting show just directory name in Thunar window title"
xfconf-query --channel thunar --property /misc-full-path-in-title  --create --type bool --set false

# when flashing arduino firmware, we need to be in the dialout group or we'll
# get access denied when trying to access the usb to serial port /dev/ttyACM0
echo "add user to dialout group"
sudo adduser john dialout
