#!/bin/bash

#==============================================================================
# Script Name    : build_ubuntu.sh
# Description    : This script includes everything necessary after a fresh
#                  Ubuntu installation.
#
# Author         : Alan MARCHAND
# Compatibility  : Bash Only
#==============================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# Check if the user is root
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "You must be a root user to execute this script." >&2
        exit 1
    fi
}

# Update the system packages
update_system() {
    echo "Updating the system..."
    apt update
    apt dist-upgrade -y
}

# Remove unnecessary packages
cleanup_packages() {
    echo "Removing unnecessary packages..."
    apt -y remove --purge screen || true
    apt -y autoremove --purge || true
}

# Install necessary packages
install_packages() {
    echo "Installing necessary packages..."
    local packages=(
        apt-transport-https
        autoconf
        automake
        binutils
        build-essential
        ccache
        ccls
        cifs-utils
        colordiff
        curl
        dbus-x11
        dislocker
        dos2unix
        elfutils
        exuberant-ctags
        flex
        gawk
        gdb
        git
        gnome-shell-extensions
        graphviz
        htop
        imagemagick
        indent
        jq
        libaio1t64
        libbz2-dev
        libcurl4-openssl-dev
        libexpat1-dev
        libpam0g
        libtool
        libxext6
        libxrender1
        libxtst6
        lsb-release
        man
        neofetch
        ncat
        nmap
        pdfgrep
        plocate
        software-properties-common
        sqlite3
        sqlite3-doc
        sharutils
        stow
        strace
        sudo
        tmux
        tree
        unixodbc
        unixodbc-dev
        libsqliteodbc
        wget
        xclip
        zlib1g-dev
    )
    apt install -y "${packages[@]}"
}

# Install Python 3
install_python() {
    read -p "Do you want to install Python 3? (y/n) " answer
    if [[ "$answer" =~ ^[yY]$ ]]; then
        echo "Installing Python 3..."
        apt install -y \
            build-essential \
            libffi-dev \
            libssl-dev \
            python3 \
            python3-pip \
            python3-venv
    fi
}

# Install Virtualization stack
install_virtualization() {
    read -p "Do you want to install Virtualization stack ? (y/n) " answer
    if [[ "$answer" =~ ^[yY]$ ]]; then
        echo "Installing Virtualization stack..."
        apt install bridge-utils \
            libvirt-clients \
            libvirt-clients-qemu \
            libvirt-daemon \
            libvirt-daemon-driver-lxc \
            libvirt-daemon-driver-vbox \
            qemu-system-x86 \
            virt-manager
    fi
}

# Install GNOME utilities
install_gnome_tools() {
    read -p "Do you want to install some GNOME utilities? (y/n) " answer
    if [[ "$answer" =~ ^[yY]$ ]]; then
        echo "Installing GNOME tools..."
        apt install -y \
            dconf-editor \
            gnome-tweaks \
            gnome-shell-extension-manager
    fi
}

# Install VLC and multimedia codecs
install_vlc() {
    read -p "Do you want to install VLC and multimedia codecs? (y/n) " answer
    if [[ "$answer" =~ ^[yY]$ ]]; then
        echo "Installing VLC and codecs..."
        apt install -y \
            ubuntu-restricted-extras \
            vlc
    fi
}

# Install X11 Forwarding dependencies
install_x11_dependencies() {
    read -p "Do you want to install X11 Forwarding dependencies? (y/n) " answer
    if [[ "$answer" =~ ^[yY]$ ]]; then
        echo "Installing X11 dependencies..."
        apt install -y \
            dbus-x11 \
            x11-apps \
            xvfb \
            xdm \
            xfonts-base \
            xfonts-100dpi \
            sxiv \
            twm \
            xterm
    fi
}

# Install and start SSH server
install_ssh_server() {
    read -p "Do you want to install the SSH server? (y/n) " answer
    if [[ "$answer" =~ ^[yY]$ ]]; then
        readonly PKG=openssh-server
        if dpkg --get-selections | grep -q "^$PKG[[:space:]]*install$" >/dev/null; then
            echo "OpenSSH server is already installed."
        else
            echo "Installing OpenSSH server..."
            apt install -y "$PKG"
        fi
    fi
}

# Update locate database
update_locate_db() {
    echo "Updating the locate database..."
    updatedb
}

# Clean up temporary files and caches
cleanup() {
    echo "Cleaning up temporary files and caches..."
    apt -y autoremove --purge || true
    apt -y clean autoclean || true
    rm -rf /tmp/*
}

# Check if the script is running on WSL
check_wsl() {
    if uname -a | grep -q "microsoft" && uname -a | grep -q "WSL"; then
        echo "Microsoft WSL2 system detected."
        echo "End of installation process."
        exit
    fi
}

# Execute functions
check_root
update_system
cleanup_packages
install_packages
install_python
install_virtualization
install_gnome_tools
install_vlc
install_x11_dependencies
install_ssh_server
update_locate_db
cleanup
check_wsl

