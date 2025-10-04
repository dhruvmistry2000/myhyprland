# Hyprland Setup Script for Arch Linux

A comprehensive setup script that installs all essential packages and configurations for Hyprland on Arch Linux.

## Features

- 🚀 **Complete Hyprland Installation** - Installs Hyprland and all dependencies
- 🎨 **Pre-configured Setup** - Ready-to-use configuration files
- 🔧 **AUR Support** - Uses yay for both official and AUR packages
- 🎯 **Single Command** - Everything installed in one go
- 📦 **Essential Packages** - Terminal, file manager, browser, development tools
- 🎵 **Audio System** - PipeWire with all necessary components
- 🖼️ **Graphics Support** - Mesa, Vulkan drivers for all hardware
- 🔤 **Fonts** - Nerd Fonts and essential typography
- 🐚 **mybash Integration** - Automatically sets up your mybash repository

## Quick Installation

### One-liner Command

```bash
curl -sSL https://raw.githubusercontent.com/dhruvmistry2000/myhyprland/main/install-oneliner.sh | bash
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/dhruvmistry2000/myhyprland.git
cd myhyprland
```

2. Make the script executable:
```bash
chmod +x install.sh
```

3. Run the installation:
```bash
./install.sh
```

## What Gets Installed

### Core Components
- **Hyprland** - Wayland compositor
- **Wayland** - Display server protocol
- **XWayland** - X11 compatibility

### Graphics & Audio
- **Mesa** - OpenGL implementation
- **Vulkan** - Graphics API support
- **PipeWire** - Audio system
- **WirePlumber** - Audio session manager

### Applications
- **Kitty** - Terminal emulator
- **Thunar** - File manager
- **Fastfetch** - System information
- **Vim/Nano** - Text editors
- **Node.js, Python, Rust, Go** - Development tools

### Utilities
- **Waybar** - Status bar
- **Dunst** - Notification daemon
- **Grim/Slurp** - Screenshot tools
- **Hyprshot** - Hyprland screenshot tool
- **FZF, Ripgrep, Bat** - Command-line tools

### Fonts
- **Nerd Fonts** - Icon fonts
- **JetBrains Mono** - Programming font
- **Hack** - Additional programming font

## Configuration Files

The script creates the following configuration files:

- `~/.config/hypr/hyprland.conf` - Main Hyprland configuration
- `~/.config/waybar/` - Waybar configuration and styling
- `~/.config/dunst/` - Dunst notification configuration

## mybash Integration

The script automatically sets up your mybash repository at `~/Github/mybash`:
- Clones the repository if it doesn't exist
- Pulls latest changes if it already exists

## Usage

After installation, you can start Hyprland by:

1. **From terminal:**
   ```bash
   Hyprland
   ```

2. **From display manager:**
   - Select "Hyprland" from the session list

## Key Bindings

- `Super + Q` - Open terminal (Kitty)
- `Super + E` - Open file manager (Thunar)
- `Super + R` - Open application launcher
- `Super + C` - Close active window
- `Super + M` - Exit Hyprland
- `Super + V` - Toggle floating window
- `Super + 1-9` - Switch workspaces
- `Super + Shift + 1-9` - Move window to workspace
- `Print` - Screenshot (full screen)
- `Shift + Print` - Screenshot (window)
- `Ctrl + Print` - Screenshot (region)

## Requirements

- Arch Linux (or Arch-based distribution)
- Internet connection
- Non-root user with sudo privileges

## Troubleshooting

### If yay installation fails:
```bash
sudo pacman -S base-devel git
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### If packages fail to install:
```bash
yay -Syu
yay -S <package-name>
```

### If Hyprland doesn't start:
- Check if you're in a Wayland session
- Ensure graphics drivers are properly installed
- Check logs: `journalctl --user -u hyprland`

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the [MIT License](LICENSE).
