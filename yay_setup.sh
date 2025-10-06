#!/bin/bash

# Define color variables for output
YELLOW='\033[33m'
GREEN='\033[32m'
RED='\033[31m'
RC='\033[0m'  # Reset color

# Define the directory name for yay
YAY_DIR="yay"
YAY_REPO="https://aur.archlinux.org/yay-bin.git"

# Function to check if the distro is Arch-based
is_arch_based() {
  if command -v pacman >/dev/null 2>&1; then
    return 0  # Arch-based
  else
    return 1  # Not Arch-based
  fi
}

# Function to check if yay is installed
is_yay_installed() {
  if command -v yay >/dev/null 2>&1; then
    return 0  # yay is installed
  else
    return 1  # yay is not installed
  fi
}

# Check if the system is Arch-based
if is_arch_based; then
  # Check if yay is installed
  if is_yay_installed; then
    echo -e "${GREEN}yay is already installed. Exiting.${RC}"
    exit 0
  else
    echo -e "${YELLOW}Starting yay installation${RC}"
    
    # Update system
    echo "Updating system..."
    sudo pacman -Syu --noconfirm

    # Install required packages
    echo "Installing base-devel and git..."
    sudo pacman -S --noconfirm base-devel git

    # Clone yay repository into the current directory
    if [ -d "$YAY_DIR" ]; then
        echo -e "${YELLOW}Directory $YAY_DIR already exists. Skipping cloning.${RC}"
    else
        echo -e "${YELLOW}Cloning yay repository into $YAY_DIR...${RC}"
        if ! git clone $YAY_REPO $YAY_DIR; then
            echo -e "${RED}Failed to clone yay repository. Please check your internet connection and try again.${RC}"
            exit 1
        fi
    fi

    # Build and install yay
    if [ -d "$YAY_DIR" ]; then
        cd $YAY_DIR
        echo -e "${YELLOW}Building and installing yay...${RC}"
        makepkg -si
        cd ..
        rm -rf $YAY_DIR
        echo -e "${GREEN}yay installation completed successfully!${RC}"
    else
        echo -e "${RED}yay directory does not exist. Cannot build yay.${RC}"
        exit 1
    fi
  fi
else
  echo -e "${RED}This script is intended for Arch-based systems only. Exiting.${RC}"
fi