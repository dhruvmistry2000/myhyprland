#!/bin/sh -e

RC='\033[0m'
RED='\033[31m'
YELLOW='\033[33m'
GREEN='\033[32m'

# Arch Linux only setup script

REPO_DIR="$HOME/Github/myhyprland"
REPO_URL="https://github.com/dhruvmistry2000/myhyprland"

# Clone or update the repository
if [ -d "$REPO_DIR" ]; then
    printf "${YELLOW}Pulling myhyprland repository at: $REPO_DIR${RC}\n"
    cd "$REPO_DIR"
    git pull
    if [ $? -eq 0 ]; then
        printf "${GREEN}Successfully pulled myhyprland repository${RC}\n"
    else
        printf "${RED}Failed to pull myhyprland repository${RC}\n"
        exit 1
    fi
else
    printf "${YELLOW}Cloning myhyprland repository into: $REPO_DIR${RC}\n"
    git clone "$REPO_URL" "$REPO_DIR"
    if [ $? -eq 0 ]; then
        printf "${GREEN}Successfully cloned myhyprland repository${RC}\n"
    else
        printf "${RED}Failed to clone myhyprland repository${RC}\n"
        exit 1
    fi
fi

GITPATH="$REPO_DIR"

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

checkEnv() {
    REQUIREMENTS='curl groups sudo wget'
    for req in $REQUIREMENTS; do
        if ! command_exists "$req"; then
            printf "${RED}To run me, you need: $REQUIREMENTS${RC}\n"
            exit 1
        fi
    done

    if ! command_exists pacman; then
        printf "${RED}This script is for Arch Linux (pacman) only.${RC}\n"
        exit 1
    fi

    if ! groups | grep -qE 'wheel|sudo|root'; then
        printf "${RED}You need to be a member of the sudo/wheel/root group to run me!${RC}\n"
        exit 1
    fi
}

installDepend() {
    printf "${YELLOW}Installing dependencies...${RC}\n"

    # Ensure AUR helper exists
    if ! command_exists yay ; then
        printf "${YELLOW}Running yay_setup.sh to install yay as AUR helper...${RC}\n"
        bash "$GITPATH/yay_setup.sh"
        if [ $? -eq 0 ]; then
            printf "${GREEN}Successfully installed yay using yay_setup.sh${RC}\n"
        else
            printf "${RED}Failed to install yay using yay_setup.sh${RC}\n"
            exit 1
        fi
    else
        printf "${GREEN}AUR helper already installed${RC}\n"
    fi

    if command_exists yay; then
        AUR_HELPER="yay"
    else
        printf "${RED}No AUR helper found. Please install yay or paru.${RC}\n"
        exit 1
    fi

    PKG_FILE="$GITPATH/packages"
    if [ -f "$PKG_FILE" ]; then
        # Read non-empty, non-comment lines, join with spaces, and install in one command
        PKGS=$(grep -Ev '^[[:space:]]*(#|$)' "$PKG_FILE" | tr '\n' ' ')
        if [ -z "$PKGS" ]; then
            printf "${RED}No packages listed in $PKG_FILE${RC}\n"
            exit 1
        fi
        ${AUR_HELPER} --noconfirm -S $PKGS
    else
        printf "${RED}Package list file not found at $PKG_FILE${RC}\n"
        exit 1
    fi

    if [ $? -eq 0 ]; then
        printf "${GREEN}Successfully installed dependencies${RC}\n"
    else
        printf "${RED}Failed to install dependencies${RC}\n"
        exit 1
    fi

    # Enable ly
    if command_exists ly; then
        printf "${GREEN}ly already installed${RC}\n"
    else
        printf "${YELLOW}Installing ly...${RC}\n"
        ${AUR_HELPER} --noconfirm -S ly
        sudo systemctl enable ly
        if [ $? -eq 0 ]; then
            printf "${GREEN}Successfully installed and enabled ly${RC}\n"
        else
            printf "${RED}Failed to install/enable ly${RC}\n"
            exit 1
        fi
    fi
}

installFont() {
    FONT_NAME="Hack"
    if fc-list :family | grep -iq "$FONT_NAME"; then
        printf "${GREEN}Font '$FONT_NAME' is installed.${RC}\n"
    else
        printf "${YELLOW}Installing font '$FONT_NAME'${RC}\n"
        FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Hack.zip"
        FONT_DIR="$HOME/.local/share/fonts"
        wget $FONT_URL -O ${FONT_NAME}.zip
        if [ $? -eq 0 ]; then
            printf "${GREEN}Successfully downloaded font '$FONT_NAME'${RC}\n"
        else
            printf "${RED}Failed to download font '$FONT_NAME'${RC}\n"
            exit 1
        fi
        unzip ${FONT_NAME}.zip -d $FONT_NAME
        if [ $? -eq 0 ]; then
            printf "${GREEN}Successfully unzipped font '$FONT_NAME'${RC}\n"
        else
            printf "${RED}Failed to unzip font '$FONT_NAME'${RC}\n"
            exit 1
        fi
        mkdir -p $FONT_DIR
        mv ${FONT_NAME}/*.ttf $FONT_DIR/
        if [ $? -eq 0 ]; then
            printf "${GREEN}Successfully moved font files to $FONT_DIR${RC}\n"
        else
            printf "${RED}Failed to move font files to $FONT_DIR${RC}\n"
            exit 1
        fi
        fc-cache -fv
        if [ $? -eq 0 ]; then
            printf "${GREEN}Successfully updated the font cache${RC}\n"
        else
            printf "${RED}Failed to update the font cache${RC}\n"
            exit 1
        fi
        rm -rf ${FONT_NAME} ${FONT_NAME}.zip
        if [ $? -eq 0 ]; then
            printf "${GREEN}Successfully deleted temporary font files${RC}\n"
        else
            printf "${RED}Failed to delete temporary font files${RC}\n"
            exit 1
        fi
        printf "${GREEN}'$FONT_NAME' installed successfully.${RC}\n"
    fi
}

moveConfigs() {
    CONFIG_SRC_DIR="$GITPATH/config"
    CONFIG_DEST_DIR="$HOME/.config"

    mkdir -p "$CONFIG_DEST_DIR"
    if [ $? -eq 0 ]; then
        printf "${GREEN}Successfully created target directory $CONFIG_DEST_DIR${RC}\n"
    else
        printf "${RED}Failed to create target directory $CONFIG_DEST_DIR${RC}\n"
        exit 1
    fi

    for config in "$CONFIG_SRC_DIR"/*; do
        if [ -d "$config" ]; then
            sudo cp -r "$config" "$CONFIG_DEST_DIR/"
            if [ $? -eq 0 ]; then
                printf "${GREEN}Copied config directory $(basename "$config") to $CONFIG_DEST_DIR${RC}\n"
            else
                printf "${RED}Failed to copy config directory $(basename "$config") to $CONFIG_DEST_DIR${RC}\n"
                printf "${YELLOW}Tip: Check if you have write permissions for $CONFIG_DEST_DIR. You may need to change ownership or permissions using 'sudo chown -R $USER:$USER $CONFIG_DEST_DIR' or 'chmod'.${RC}\n"
                exit 1
            fi
        fi
    done
}

installMyBashConfig() {
    curl -sSL https://raw.githubusercontent.com/dhruvmistry2000/mybash/master/setup.sh | bash
    if [ $? -eq 0 ]; then
        printf "${GREEN}My Bash configuration installed successfully!${RC}\n"
    else
        printf "${RED}Failed to install My Bash configuration.${RC}\n"
    fi
}

wallpaper() {
    if [ -f wallpaper.sh ]; then
        sudo chmod +x wallpaper.sh
        bash wallpaper.sh
        printf "${GREEN}Wallpapers downloaded successfully!${RC}\n"
    else
        printf "${RED}wallpaper.sh not found.${RC}\n"
    fi
}
theme() {
    if [ -f theme.sh ]; then
        sudo chmod +x theme.sh
        bash theme.sh
        printf "${GREEN}Wtheme downloaded successfully!${RC}\n"
    else
        printf "${RED}theme.sh not found.${RC}\n"
    fi
}

checkEnv
installDepend
moveConfigs
installFont
installMyBashConfig
wallpaper
theme