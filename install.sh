#!/bin/bash

# Hyprland Setup Script for Arch Linux
# This script installs all essential packages for a complete Hyprland experience


# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


# Define the repository path and configuration file
REPO_DIR="$HOME/Github/myhyprland"
REPO_URL="https://github.com/dhruvmistry2000/myhyprland"

# Check if the repository directory exists, create it if it doesn't
if [ -d "$REPO_DIR" ]; then
    printf "${YELLOW}Pulling mybash repository at: $REPO_DIR${RC}\n"
    cd "$REPO_DIR"
    git pull
    if [ $? -eq 0 ]; then
        printf "${GREEN}Successfully pulled mybash repository${RC}\n"
    else
        printf "${RED}Failed to pull mybash repository${RC}\n"
    fi
else
    printf "${YELLOW}Cloning mybash repository into: $REPO_DIR${RC}\n"
    git clone "$REPO_URL" "$REPO_DIR"
    if [ $? -eq 0 ]; then
        printf "${GREEN}Successfully cloned mybash repository${RC}\n"
    else
        printf "${RED}Failed to clone mybash repository${RC}\n"
    fi
fi

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root. Please run as a regular user."
   exit 1
fi

# Check if pacman is available
if ! command -v pacman &> /dev/null; then
    print_error "pacman not found. This script is designed for Arch Linux."
    exit 1
fi

print_status "Starting Hyprland setup for Arch Linux..."

# Function to update system
update_system() {
    print_status "Updating system packages..."
    sudo pacman -Syu --noconfirm
}

# Function to install yay AUR helper
install_yay() {
    print_status "Installing yay AUR helper using yay_setup.sh..."
    if [ -f "./yay_setup.sh" ]; then
        chmod +x ./yay_setup.sh
        ./yay_setup.sh
        print_success "yay installed successfully using yay_setup.sh"
    else
        print_error "yay_setup.sh not found. Please ensure it's in the same directory."
        exit 1
    fi
}

# Function to install Hyprland and dependencies
install_hyprland_dependencies() {
    print_status "Installing all Hyprland packages and dependencies..."
    yay -S --noconfirm \
        hyprland \
        ntfs-3g \
        nwg-displays \
        ly \
        brave-bin \
        google-chrome \
        spotify \
        flameshot \
        code \
        rofi \
        obs-studio \
        pipewire \
        wireplumber \
        xdg-desktop-portal \
        xdg-desktop-portal-hyprland \
        wayland \
        wayland-protocols \
        xorg-server-xwayland \
        xorg-xwayland \
        mesa \
        vulkan-radeon \
        vulkan-intel \
        vulkan-mesa-layers \
        lib32-vulkan-radeon \
        lib32-vulkan-intel \
        lib32-vulkan-mesa-layers \
        mesa-utils \
        vulkan-tools \
        pipewire \
        pipewire-alsa \
        pipewire-pulse \
        pipewire-jack \
        wireplumber \
        pavucontrol \
        alsa-utils \
        kitty \
        thunar \
        fastfetch \
        vim \
        nano \
        wlr-randr \
        wl-clipboard \
        grim \
        slurp \
        swappy \
        wf-recorder \
        hyprshot \
        hyprpicker \
        dunst \
        libnotify \
        waybar \
        eww-wayland \
        lf \
        fzf \
        ripgrep \
        bat \
        exa \
        tree \
        nodejs \
        npm \
        python \
        python-pip \
        rust \
        go \
        gcc \
        clang \
        ttf-font-awesome \
        ttf-jetbrains-mono \
        ttf-nerd-fonts-symbols \
        noto-fonts \
        noto-fonts-emoji \
        hyprland-nvidia-git \
        waybar-hyprland-git \
        hyprland-autoname-workspaces \
        hyprland-workspace-switcher  \
        bluez  \
        bluez-utils  \
        blueman  \
        fzf \
        materia-gtk-theme  \
        nvtop
}

# Function to install a font if not already installed
install_font() {
        FONT_NAME="Hack"
    if fc-list :family | grep -iq "$FONT_NAME"; then
        printf "Font '$FONT_NAME' is installed.\n"
    else
        printf "Installing font '$FONT_NAME'\n"
        # Change this URL to correspond with the correct font
        FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip"
        FONT_DIR="$HOME/.local/share/fonts"
        wget $FONT_URL -O ${FONT_NAME}.zip
        unzip ${FONT_NAME}.zip -d $FONT_NAME
        mkdir -p $FONT_DIR
        mv ${FONT_NAME}/*.ttf $FONT_DIR/
        # Update the font cache
        fc-cache -fv
        rm -rf "${FONT_NAME}" "${FONT_NAME}.zip"
        printf "'%s' installed successfully.\n" "$FONT_NAME"
    fi
}

# Function to create Hyprland config directory
create_hyprland_config_dir() {
    print_status "Copying configuration files to ~/.config..."
    mkdir -p ~/.config
    cp -r config/* ~/.config/
}

# Function to setup mybash repository
setup_mybash_repo() {
    # Define the repository path and configuration file
    REPO_DIR="$HOME/Github/mybash"
    REPO_URL="https://github.com/dhruvmistry2000/mybash"

    # Check if the repository directory exists, create it if it doesn't
    if [ -d "$REPO_DIR" ]; then
        print_status "Pulling mybash repository at: $REPO_DIR"
        cd "$REPO_DIR"
        git pull
        if [ $? -eq 0 ]; then
            print_success "Successfully pulled mybash repository"
        else
            print_error "Failed to pull mybash repository"
        fi
    else
        print_status "Cloning mybash repository into: $REPO_DIR"
        git clone "$REPO_URL" "$REPO_DIR"
        if [ $? -eq 0 ]; then
            print_success "Successfully cloned mybash repository"
        else
            print_error "Failed to clone mybash repository"
        fi
    fi
}

# Main execution
update_system
install_yay
install_hyprland_dependencies
install_font
setup_mybash_repo
create_hyprland_config_dir

print_success "Hyprland setup completed successfully!"
print_status "You can now start Hyprland by running: Hyprland"
print_status "Or select it from your display manager if you have one installed."
print_warning "Make sure to restart your system or log out and back in for all changes to take effect."
print_status "Configuration files have been created in ~/.config/hypr/, ~/.config/waybar/, and ~/.config/dunst/"
print_status "mybash repository has been set up at ~/Github/mybash"
