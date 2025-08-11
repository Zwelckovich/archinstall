#!/bin/bash
#
# 🌱 BONSAI Arch Linux Installer
# Enhanced installation experience with BONSAI aesthetics
#

## BONSAI Color Palette
BONSAI_GREEN="\e[38;2;124;152;133m"   # Primary accent (#7c9885)
BONSAI_BLUE="\e[38;2;130;164;199m"    # Information (#82a4c7)
BONSAI_YELLOW="\e[38;2;199;168;130m"  # Warnings (#c7a882)
BONSAI_RED="\e[38;2;199;130;137m"     # Errors (#c78289)
BONSAI_PURPLE="\e[38;2;152;130;199m"  # Special (#9882c7)
BONSAI_TEXT="\e[38;2;230;232;235m"    # Primary text (#e6e8eb)
BONSAI_MUTED="\e[38;2;139;146;165m"   # Secondary text (#8b92a5)
BONSAI_RESET="\e[0m"

# Status indicators with BONSAI colors
CNT="${BONSAI_BLUE}[→]${BONSAI_RESET}"
COK="${BONSAI_GREEN}[✓]${BONSAI_RESET}"
CER="${BONSAI_RED}[✗]${BONSAI_RESET}"
CAT="${BONSAI_YELLOW}[!]${BONSAI_RESET}"
CWR="${BONSAI_PURPLE}[⚠]${BONSAI_RESET}"
CAC="${BONSAI_GREEN}[⟳]${BONSAI_RESET}"
INSTLOG="install_bonsai.log"

# Global variables for installation choices
SELECTED_DISK=""
SELECTED_DISK_NAME=""
USE_ENCRYPTION=true
CPU_TYPE=""
PARTITION1=""
PARTITION2=""

## Package arrays (preserved from original)
hypr_base_stage=(
  # Hyprland
  kitty                        # A fast, feature-rich terminal emulator focused on simplicity and efficiency.
  pamixer                      # A command-line tool to control pulseaudio volumes.
  pavucontrol                  # A graphical volume control for PulseAudio sound server.
  pipewire-alsa                # ALSA plugin for PipeWire, enabling audio support through PipeWire.
  playerctl                    # A command-line tool to control media players that support the MPRIS interface.
  rofi-wayland                 #  A window switcher and application launcher with Wayland support.
  waybar                       # A lightweight status bar for Wayland environments like Hyprland or Sway.
  sddm                         # The Simple Desktop Display Manager, a display manager for Linux systems.
  hyprcursor                   # Custom cursors for use with Hyprland.
  hyprutils                    # Collection of tools and utilities for enhancing Hyprland functionality.
  hypridle                     # Screen locker utility for Hyprland with customization options.
  hyprlock                     # Screen locking tool integrated into Hyprland, featuring blur effects.
  hyprland                     # The core window manager providing tiling, floating, and fullscreen functionality.
  pyprland                     # Python utility to extend Hyprland's capabilities for custom scripting.
  swww                         # Wallpaper setter designed specifically for Wayland environments.
  swaync                       # Notification utility tailored for Sway, enhancing desktop notifications.
  wl-clipboard                 # Clipboard manager for wayland
  clipse                       # A configurable TUI clipboard manager for Unix.
                               # Fonts
  adobe-source-code-pro-fonts  # Monospaced font family optimized for coding environments.
  noto-fonts-emoji             # Set of emoji characters supporting various platforms and applications.
  otf-font-awesome             # Icon font providing a wide range of scalable vector icons.
  ttf-droid                    # Open-ource fonts based on the Roboto typeface, designed for clarity and readability.
  ttf-fira-code                # Monospaced programming font with ligature support, enhancing code legibility.
  ttf-jetbrains-mono           # Monospaced font optimized for programming environments, offering excellent character spacing.
  ttf-jetbrains-mono-nerd      # Jetbrains Mono variant with Nerd Font glyphs, combining programming features with additional icons and symbols.
                               # GTK / Qt Themes
  qt5ct                        # Configuration tool for Qt5 applications to customize themes and appearance.
  qt6ct                        # Configuration tool for Qt6 applications ensuring compatibility with modern Qt versions.
  catppuccin-cursors-mocha     # Set of cursors styled according to the Catppuccin theme, offering a cohesive visual experience with the 'mocha' color variant.
  nwg-look                     # Tool designed to customize desktop appearance, including themes and icons for a visually appealing setup.
)

piperwire_stage=(
  # Pipewire
  pipewire        # Core audio and media processing framework for Linux.
  wireplumber     # Session manager for PipeWire, simplifying audio and video routing.
  pipewire-audio  # Audio support module for PipeWire.
  pipewire-alsa   # ALSA compatibility layer for PipeWire, enabling traditional ALSA applications to work with PipeWire.
  pipewire-pulse  # PulseAudio compatibility layer for PipeWire, allowing PulseAudio-based applications to use PipeWire.
  sof-firmware    # Firmware for Intel Sound Open Firmware (SOF) audio platforms.
)

tools_stage=(
  # Display /  Audio / Core
  feh                     # Lightweight image viewer for X11 with support for various image formats.
  pacman-contrib          # Additional tools and scripts for Pacman, enhancing package management capabilities.
  npm                     # Node Package Manager for installing, sharing, and managing JavaScript packages.
                          # Web Tools
  vivaldi                 # An advanced browser made with the power user in mind.
  vivaldi-ffmpeg-codecs   # additional support for proprietary codecs for vivaldi
                          # Programming Tools
  visual-studio-code-bin  # The Visual Studio Code editor, providing a robust development environment.
  pycharm-professional    # Pycharm Community edition IDE
  webstorm                # JavaScript and Typscript IDE from Jetbrains
  qt5-graphicaleffects    # Qt module for advanced graphical effects in Qt applications.
  qt5-svg                 # SVG support module for Qt applications.
  qt6-svg                 # SVG support module compatible with Qt6 versions.
  qt5-quickcontrols2      # Module offering modern controls for creating quick, visually appealing user interfaces in Qt applications.
  eza                     # Enhanced version of the `ls` command, providing more detailed and customizable directory listings.
  hyfetch                 # Lightweight system information tool optimized for Hyprland environments.
  bfg                     # Remove big files from GIT repositories
  git-crypt               # Extension for managing encrypted files in Git repositories.
  git-lfs                 # Large File Storage extension for Git, allowing efficient handling of large files.
  github-cli              # Github CLI client
  python                  # High-level programming language known for its readability and versatility.
  python-pip              # Package installer for Python, simplifying package management.
  pyenv                   # Tool to manage multiple Python versions and environments.
  uv                      # An extremely fast Python package installer and resolver written in Rust
  python-pynvim           # Python Client for Neovim
  tk                      # Tkinter library – Python's standard GUI toolkit.
  rust                    # Programming language focused on safety, speed, and concurrency with a modern syntax.
  docker                  # Pack, ship and excecute lightweight container
  yarn                    # Fast, reliable, and secure dependency management
  claude-code             # An agentic coding tool that lives in your terminal
  shfmt                   # Format shell programs
  stylua                  # Deterministic code formatter for Lua
  luacheck                # A tool for linting and static analysis of Lua code
  prettier                # An opinionated code formatter
                          # Science Tools
  step
  # Office Tools
  texlive             # TeX Live LaTeX framework from AUR-Arch
  texlive-langgerman  # Provides German language support for TeX Live
  zathura             # Lightweight PDF viewer with support for multiple backends (e.g., MuPDF, Poppler)
  zathura-pdf-mupdf   # Zathura plugin using the MuPDF PDF renderer
  meld                # Graphical tool for merging and comparing files
  baobab              # Disk usage analyzer with a graphical interface, alternative to Treesize
  neomutt             # Modern mutt email client with enhanced features
  w3m                 # Text-based web browser with inline image support for HTML emails
  lynx                # Alternative text browser for HTML conversion
  urlscan             # Extract and follow URLs from emails
  isync               # IMAP synchronization tool (mbsync)
  msmtp               # SMTP client for sending emails
  pass                # Password manager for secure email credentials
  abook               # Address book for mutt
  calcurse            # Text-based calendar and scheduling application with todo lists
  d2                  # A modern diagram scripting language that turns text to diagrams
                      # Audio/Video/Foto Tools
  ffmpeg              # Complete Solution to record, convert and stream audio and video
  audacity            # Audio edit tool
  yt-dlp              # Video and Audio Downloader
  mpv                 # a free, open source, and cross-platform media player
  ncspot              # Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes.
  inkscape            # Open-source vector graphics editor with capabilities similar to Adobe Illustrator.
  grim                # Screenshot utility for Wayland
  slurp               # Select a region in a Wayland compositor
  tesseract           # An OCR program
  tesseract-data-eng  # English OCR database
  tesseract-data-deu  # German OCR database
  chromium-widevine   # DRM Tool for chomium based browsers to watch Netflix in full quality
  blender             # A fully integrated 3D graphics creation suite
                      # CLI Tools
  btop                # Interactive system monitoring tool similar to htop but built using libui.
  lazygit             # TUI (text user interface) for Git operations designed to be intuitive and fast.
  stow                # Tool for managing symlinks, useful for installing software globally while keeping configuration files in a central location.
  zsh                 # Robust shell with advanced features, including syntax highlighting and plugins support.
  fzf                 # Fuzzy file finder that allows you to search through files quickly using partial matches.
  fd                  # Simple, fast, user-friendly alternative to find, optimized for common use cases.
  bat                 # Modern replacement for cat, displaying colored output in terminals when viewing text files.
  git-delta           # Colors and formats Git diffs with syntax highlighting, making them easier to read.
  tlrc                # Terminal-based image viewer focused on low resource usage with a dark theme by default.
  thefuck             # Tool that corrects your mistyped commands automatically by finding similar valid commands.
  zoxide              # CLI tool that helps you quickly jump between directories using fuzzy search.
  reflector           # AUR helper designed to speed up updates and package installations by optimizing mirrors in /etc/pacman.conf.
  ripgrep             # Fast, modern search tool that looks for patterns in files, similar to grep but with additional features like regex support.
  tre-command         # CLI tool for managing SSH connections and identities with tab-completion and command history.
  unzip               # Command-line utility for extracting files from ZIP archives.
  ni-visa             # Tool for querying information about network interfaces, including MAC addresses and IP details.
  expac               # Enhanced version of the pacman package manager, providing more detailed output and easier scripting capabilities.
  scc                 # Simple Console Calculator for performing quick calculations directly in the terminal.
  duf                 # Disk usage analysis tool that provides a detailed overview of storage space usage on your system.
  rsync               # Fast and versatile file synchronization tool, often used for backups or transferring large amounts of data efficiently.
  dua-cli             # Command-line tool to analyze disk usage across directories, providing insights into which files and folders consume the most space.
  sox                 # Sound eXchange - A command-line audio player, recorder, and editor with support for various audio formats and effects.
  testdisk            # Data recovery and disk repair tool
  ncdu                # Command-line disk usage analyzer, alternative to baobab
  cifs-utils          # CIFS filesystem user-space tools
  smbclient           #Tools to access a server's filespace and printers via SMB
  openssh             # SSH protocol implementation for remote login, command execution and file transfer
                      # Yazi
  file                # Determine file type
  ueberzugpp          # File Preview
  chafa               # Image-to-text converter supporting a wide range of symbols and palettes, transparency, animations, etc.
  jq                  # Command-line JSON processor
  yazi                # CLI file explorer
                      # Gaming
  steam               # Steam platform client
  lutris              # Lutris game launcher for epic or gog etc.
  discord             #All-in-one voice and text chat for gamers
                      # Electronics/RF
  qucs-s              # A spin-off of Qucs that supports other free SPICE circuit simulators like ngspice with the same Qucs GUI
  paraview            # Parallel Visualization application using VTK
                      # Bluetooth
  bluez
  bluez-utils
  blueman
)

#software for nvidia GPU only
nvidia_stage=(
  linux-headers            # Kernel headers for compiling drivers
  nvidia                   # NVIDIA driver with DKMS support
  nvidia-settings          # GUI tool for adjusting graphics settings
  nvidia-utils             # Tools for monitoring and managing GPU usage
  libva                    # Video acceleration library for offloading video tasks
  libva-nvidia-driver-git  # NVIDIA-specific VA drivers from Git repository
  cuda                     # NVIDIA's platform for GPU-accelerated computing
)

uninstall_stage=(
  dunst       # Notification daemon for managing system notifications
  mako        # Application launcher with workspace and window management support
  rofi        # Window switcher and application launcher with a simple, fast interface
  allust-git  # Graphical tool for monitoring system resources (fork of Alust)
)

uninstall_nvidia_stage=(
  hyprland-git               # Development version of Hyprland (Wayland compositor)
  hyprland-nvidia            # Hyprland optimized for NVIDIA GPUs with proper driver support
  hyprland-nvidia-git        # Development version of Hyprland specifically for NVIDIA GPUs
  hyprland-nvidia-hidpi-git  # Hyprland build for NVIDIA GPUs with HiDPI (high resolution) screen support
)

# BONSAI styled header
function show_bonsai_header() {
  clear
  echo -e "${BONSAI_GREEN}"
  echo "┌─────────────────────────────────────────────────────────────────────────────┐"
  echo "│                                                                             │"
  echo "│        🌱 ██████╗  ██████╗ ███╗   ██╗███████╗ █████╗ ██╗ 🌱                │"
  echo "│          ██╔══██╗██╔═══██╗████╗  ██║██╔════╝██╔══██╗██║                   │"
  echo "│          ██████╔╝██║   ██║██╔██╗ ██║███████╗███████║██║                   │"
  echo "│          ██╔══██╗██║   ██║██║╚██╗██║╚════██║██╔══██║██║                   │"
  echo "│          ██████╔╝╚██████╔╝██║ ╚████║███████║██║  ██║██║                   │"
  echo "│          ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝                   │"
  echo "│                                                                             │"
  echo "│           █████╗ ██████╗  ██████╗██╗  ██╗   ██╗███╗   ██╗███████╗██╗  ██╗ │"
  echo "│          ██╔══██╗██╔══██╗██╔════╝██║  ██║   ██║████╗  ██║██╔════╝╚██╗██╔╝ │"
  echo "│          ███████║██████╔╝██║     ███████║   ██║██╔██╗ ██║███████╗ ╚███╔╝  │"
  echo "│          ██╔══██║██╔══██╗██║     ██╔══██║   ██║██║╚██╗██║╚════██║ ██╔██╗  │"
  echo "│          ██║  ██║██║  ██║╚██████╗██║  ██║   ███████╗╚████║███████║██╔╝ ██╗ │"
  echo "│          ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚══════╝ ╚═══╝╚══════╝╚═╝  ╚═╝ │"
  echo "│                                                                             │"
  echo "│                        ${BONSAI_MUTED}Minimal • Purposeful • Beautiful${BONSAI_GREEN}                      │"
  echo "│                                                                             │"
  echo "└─────────────────────────────────────────────────────────────────────────────┘"
  echo -e "${BONSAI_RESET}"
}

# BONSAI styled section header
function show_section() {
  local title="$1"
  echo -e "\n${BONSAI_GREEN}╭─────────────────────────────────────────────────────────────────────────────╮${BONSAI_RESET}"
  echo -e "${BONSAI_GREEN}│ ${BONSAI_TEXT}$title${BONSAI_GREEN} │${BONSAI_RESET}"
  echo -e "${BONSAI_GREEN}╰─────────────────────────────────────────────────────────────────────────────╯${BONSAI_RESET}\n"
}

# BONSAI styled progress indicator
function show_progress() {
  local pid=$1
  local message="${2:-Processing}"

  echo -en "${CNT} ${BONSAI_TEXT}${message}${BONSAI_RESET} "

  while ps -p $pid &> /dev/null; do
    echo -en "${BONSAI_GREEN}•${BONSAI_RESET}"
    sleep 0.5
  done

  echo -e " ${COK}"
}

# Interactive disk selection with BONSAI styling
function select_disk() {
  show_section "Disk Selection"

  echo -e "${CNT} ${BONSAI_TEXT}Detecting available disks...${BONSAI_RESET}\n"

  # Get disk information
  local disks=($(lsblk -dno NAME,TYPE | grep disk | awk '{print $1}'))
  local disk_info=()
  local menu_items=()

  for i in "${!disks[@]}"; do
    local disk="${disks[$i]}"
    local size=$(lsblk -dno SIZE /dev/$disk 2> /dev/null)
    local model=$(lsblk -dno MODEL /dev/$disk 2> /dev/null | sed 's/ *$//')

    if [ -z "$model" ]; then
      model="Unknown"
    fi

    disk_info+=("$disk|$size|$model")
    local index=$((i + 1))
    echo -e "  ${BONSAI_GREEN}[$index]${BONSAI_RESET} ${BONSAI_TEXT}/dev/$disk${BONSAI_RESET} - ${BONSAI_MUTED}$size - $model${BONSAI_RESET}"
  done

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select disk for installation [1-${#disks[@]}]: ${BONSAI_RESET})" disk_choice

  if [[ "$disk_choice" =~ ^[0-9]+$ ]] && [ "$disk_choice" -ge 1 ] && [ "$disk_choice" -le "${#disks[@]}" ]; then
    SELECTED_DISK="${disks[$((disk_choice - 1))]}"
    SELECTED_DISK_NAME="/dev/$SELECTED_DISK"

    echo -e "\n${COK} ${BONSAI_TEXT}Selected: ${BONSAI_GREEN}$SELECTED_DISK_NAME${BONSAI_RESET}"

    # Show current partition layout
    echo -e "\n${CNT} ${BONSAI_TEXT}Current partition layout:${BONSAI_RESET}"
    echo -e "${BONSAI_MUTED}"
    lsblk $SELECTED_DISK_NAME
    echo -e "${BONSAI_RESET}"

    # Confirmation
    echo -e "\n${CWR} ${BONSAI_YELLOW}WARNING: This will DESTROY all data on $SELECTED_DISK_NAME${BONSAI_RESET}"
    read -p "$(echo -e ${BONSAI_RED}Are you sure? [y/N]: ${BONSAI_RESET})" confirm

    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
      echo -e "${CER} ${BONSAI_RED}Installation cancelled${BONSAI_RESET}"
      exit 1
    fi
  else
    echo -e "${CER} ${BONSAI_RED}Invalid selection${BONSAI_RESET}"
    exit 1
  fi
}

# Encryption choice with BONSAI styling
function select_encryption() {
  show_section "Encryption Configuration"

  echo -e "${CNT} ${BONSAI_TEXT}Choose installation type:${BONSAI_RESET}\n"
  echo -e "  ${BONSAI_GREEN}[1]${BONSAI_RESET} ${BONSAI_TEXT}Encrypted installation${BONSAI_RESET} ${BONSAI_MUTED}(Recommended for laptops)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[2]${BONSAI_RESET} ${BONSAI_TEXT}Standard installation${BONSAI_RESET} ${BONSAI_MUTED}(No encryption)${BONSAI_RESET}"

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select option [1-2]: ${BONSAI_RESET})" enc_choice

  case $enc_choice in
    1)
      USE_ENCRYPTION=true
      echo -e "\n${COK} ${BONSAI_TEXT}Encryption ${BONSAI_GREEN}ENABLED${BONSAI_RESET}"
      ;;
    2)
      USE_ENCRYPTION=false
      echo -e "\n${COK} ${BONSAI_TEXT}Encryption ${BONSAI_YELLOW}DISABLED${BONSAI_RESET}"
      ;;
    *)
      echo -e "${CER} ${BONSAI_RED}Invalid selection, defaulting to encrypted${BONSAI_RESET}"
      USE_ENCRYPTION=true
      ;;
  esac
}

# CPU selection with BONSAI styling
function select_cpu() {
  show_section "CPU Configuration"

  echo -e "${CNT} ${BONSAI_TEXT}Select your CPU type:${BONSAI_RESET}\n"
  echo -e "  ${BONSAI_GREEN}[1]${BONSAI_RESET} ${BONSAI_TEXT}Intel${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[2]${BONSAI_RESET} ${BONSAI_TEXT}AMD${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[3]${BONSAI_RESET} ${BONSAI_TEXT}Virtual Machine${BONSAI_RESET}"

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select CPU [1-3]: ${BONSAI_RESET})" cpu_choice

  case $cpu_choice in
    1) CPU_TYPE="intel" ;;
    2) CPU_TYPE="amd" ;;
    3) CPU_TYPE="vm" ;;
    *)
      echo -e "${CER} ${BONSAI_RED}Invalid selection${BONSAI_RESET}"
      exit 1
      ;;
  esac

  echo -e "\n${COK} ${BONSAI_TEXT}CPU Type: ${BONSAI_GREEN}$CPU_TYPE${BONSAI_RESET}"
}

function pacman_init() {
  show_bonsai_header
  show_section "Pacman Initialization"

  echo -e "${CNT} ${BONSAI_TEXT}Initializing pacman keys...${BONSAI_RESET}"
  pacman-key --init
  pacman-key --populate archlinux

  echo -e "${CNT} ${BONSAI_TEXT}Configuring pacman...${BONSAI_RESET}"
  variable="Color"
  sed -i "/^#$variable/ c$variable" /etc/pacman.conf
  variable="ParallelDownloads = 5"
  sed -i "/^#$variable/ c$variable" /etc/pacman.conf
  sed -i '/^Color/a ILoveCandy' /etc/pacman.conf

  echo -e "${COK} ${BONSAI_TEXT}Pacman configured successfully${BONSAI_RESET}"
}

function btrfs_format() {
  show_section "Disk Partitioning & Formatting"

  # Select disk interactively
  select_disk

  # Select encryption
  select_encryption

  echo -e "\n${CNT} ${BONSAI_TEXT}Preparing disk...${BONSAI_RESET}"

  # Unmount any mounted partitions
  umount /dev/${SELECTED_DISK}?* 2> /dev/null
  umount -l /mnt 2> /dev/null

  # Zap the disk and create partitions
  echo -e "${CNT} ${BONSAI_TEXT}Creating partition layout...${BONSAI_RESET}"
  sgdisk --zap-all /dev/$SELECTED_DISK
  sgdisk -n 1:0:+1G -n 2:0:0 -t 1:ef00 -t 2:8300 /dev/$SELECTED_DISK -p

  # Set partition names based on disk type
  if [[ "$SELECTED_DISK" == nvme* ]]; then
    PARTITION1="/dev/${SELECTED_DISK}p1"
    PARTITION2="/dev/${SELECTED_DISK}p2"
  else
    PARTITION1="/dev/${SELECTED_DISK}1"
    PARTITION2="/dev/${SELECTED_DISK}2"
  fi

  # Format boot partition
  echo -e "${CNT} ${BONSAI_TEXT}Formatting boot partition...${BONSAI_RESET}"
  mkfs.fat -F32 "$PARTITION1"

  if [ "$USE_ENCRYPTION" = true ]; then
    show_section "Setting Up Encryption"

    echo -e "${CWR} ${BONSAI_YELLOW}You will be prompted to enter the encryption password${BONSAI_RESET}"
    echo -e "${CNT} ${BONSAI_TEXT}Choose a strong password and remember it!${BONSAI_RESET}\n"

    cryptsetup -c aes-xts-plain64 --key-size=512 --hash=sha512 --iter-time=3000 \
      --pbkdf=pbkdf2 --use-random luksFormat --type=luks1 "$PARTITION2"

    echo -e "\n${CNT} ${BONSAI_TEXT}Opening encrypted container...${BONSAI_RESET}"
    cryptsetup luksOpen "$PARTITION2" root

    # Format with BTRFS
    echo -e "${CNT} ${BONSAI_TEXT}Creating BTRFS filesystem...${BONSAI_RESET}"
    mkfs.btrfs -f /dev/mapper/root

    # Create subvolumes
    echo -e "${CNT} ${BONSAI_TEXT}Creating BTRFS subvolumes...${BONSAI_RESET}"
    mount /dev/mapper/root /mnt
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    umount /mnt

    # Mount subvolumes
    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ /dev/mapper/root /mnt
    mkdir -p /mnt/{boot,home}
    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home /dev/mapper/root /mnt/home
  else
    # Non-encrypted installation
    echo -e "${CNT} ${BONSAI_TEXT}Creating BTRFS filesystem (non-encrypted)...${BONSAI_RESET}"
    mkfs.btrfs -f "$PARTITION2"

    # Create subvolumes
    echo -e "${CNT} ${BONSAI_TEXT}Creating BTRFS subvolumes...${BONSAI_RESET}"
    mount "$PARTITION2" /mnt
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    umount /mnt

    # Mount subvolumes
    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ "$PARTITION2" /mnt
    mkdir -p /mnt/{boot,home}
    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home "$PARTITION2" /mnt/home
  fi

  # Mount boot partition
  mount "$PARTITION1" /mnt/boot

  echo -e "${COK} ${BONSAI_TEXT}Disk preparation complete${BONSAI_RESET}"

  # Select CPU type
  select_cpu

  show_section "Installing Base System"

  echo -e "${CNT} ${BONSAI_TEXT}Installing Arch Linux base system...${BONSAI_RESET}"
  echo -e "${BONSAI_MUTED}This may take a while...${BONSAI_RESET}\n"

  case $CPU_TYPE in
    intel) pacstrap /mnt base linux linux-firmware nano intel-ucode btrfs-progs ;;
    amd) pacstrap /mnt base linux linux-firmware nano amd-ucode btrfs-progs ;;
    vm) pacstrap /mnt base linux linux-firmware nano btrfs-progs ;;
  esac

  echo -e "\n${CNT} ${BONSAI_TEXT}Generating fstab...${BONSAI_RESET}"
  genfstab -U /mnt >> /mnt/etc/fstab

  echo -e "${COK} ${BONSAI_TEXT}Base system installed${BONSAI_RESET}"
}

function base_config() {
  show_bonsai_header
  show_section "System Configuration"

  echo -e "${CNT} ${BONSAI_TEXT}Please provide system information:${BONSAI_RESET}\n"

  read -p "$(echo -e ${BONSAI_YELLOW}Enter username: ${BONSAI_RESET})" userstr
  read -p "$(echo -e ${BONSAI_YELLOW}Enter hostname: ${BONSAI_RESET})" hoststr

  echo -e "\n${CNT} ${BONSAI_TEXT}Configuring timezone...${BONSAI_RESET}"
  arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
  arch-chroot /mnt hwclock --systohc

  echo -e "${CNT} ${BONSAI_TEXT}Configuring locale...${BONSAI_RESET}"
  variable="en_US.UTF-8 UTF-8"
  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/locale.gen
  arch-chroot /mnt locale-gen
  arch-chroot /mnt bash -c "echo \"LANG=en_US.UTF-8\" >> /etc/locale.conf"
  arch-chroot /mnt bash -c "echo \"KEYMAP=de-latin1-nodeadkeys\"  >> /etc/vconsole.conf"

  echo -e "${CNT} ${BONSAI_TEXT}Setting hostname...${BONSAI_RESET}"
  cmdstr="echo \"$hoststr\" >> /etc/hostname"
  arch-chroot /mnt bash -c "$cmdstr"
  arch-chroot /mnt bash -c "echo \"127.0.0.1	localhost\" >> /etc/hosts"
  arch-chroot /mnt bash -c "echo \"::1		localhost\" >> /etc/hosts"
  cmdstr="echo \"127.0.1.1	$hoststr.localdomain	$hoststr\" >> /etc/hosts"
  arch-chroot /mnt bash -c "$cmdstr"

  show_section "Root Password"
  echo -e "${CWR} ${BONSAI_YELLOW}Please set the root password:${BONSAI_RESET}"
  arch-chroot /mnt passwd

  echo -e "\n${CNT} ${BONSAI_TEXT}Configuring pacman...${BONSAI_RESET}"
  variable="Color"
  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/pacman.conf
  variable="ParallelDownloads = 5"
  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/pacman.conf
  arch-chroot /mnt sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
  arch-chroot /mnt pacman-key --init
  arch-chroot /mnt pacman-key --populate archlinux

  echo -e "${CNT} ${BONSAI_TEXT}Installing essential packages...${BONSAI_RESET}"
  arch-chroot /mnt pacman -Syy
  arch-chroot /mnt pacman --noconfirm -S grub grub-btrfs efibootmgr base-devel linux-headers networkmanager network-manager-applet wpa_supplicant dialog os-prober mtools dosfstools reflector git ntfs-3g xdg-utils xdg-user-dirs neovim vim vi wget iwd ntp archlinux-keyring bash-completion
  arch-chroot /mnt pacman --noconfirm -S broadcom-wl-dkms

  echo -e "${CNT} ${BONSAI_TEXT}Configuring initramfs...${BONSAI_RESET}"
  variable="MODULES=()"
  variable_changed="MODULES=(btrfs)"
  arch-chroot /mnt sed -i "/^$variable/ c$variable_changed" /etc/mkinitcpio.conf

  if [ "$USE_ENCRYPTION" = true ]; then
    variable="HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)"
    variable_changed="HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)"
    arch-chroot /mnt sed -i "/^$variable/ c$variable_changed" /etc/mkinitcpio.conf
  fi

  arch-chroot /mnt mkinitcpio -p linux

  show_section "Bootloader Configuration"

  echo -e "${CNT} ${BONSAI_TEXT}Installing GRUB...${BONSAI_RESET}"
  arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=BONSAI

  echo -e "${CNT} ${BONSAI_TEXT}Configuring GRUB...${BONSAI_RESET}"
  variable="GRUB_DISABLE_OS_PROBER=false"
  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/default/grub

  if [ "$USE_ENCRYPTION" = true ]; then
    variable="GRUB_ENABLE_CRYPTODISK=y"
    arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/default/grub

    # Get UUID automatically
    deviceUUID=$(blkid -s UUID -o value $PARTITION2)
    variable="GRUB_CMDLINE_LINUX="""
    variable_changed="GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${deviceUUID}:root:allow-discards\""
    arch-chroot /mnt sed -i "/^$variable/ c$variable_changed" /etc/default/grub

    echo -e "${COK} ${BONSAI_TEXT}Encryption configured for GRUB${BONSAI_RESET}"
  fi

  arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

  echo -e "\n${CNT} ${BONSAI_TEXT}Creating user account...${BONSAI_RESET}"
  arch-chroot /mnt useradd -mG wheel $userstr

  show_section "User Password"
  echo -e "${CWR} ${BONSAI_YELLOW}Please set password for user $userstr:${BONSAI_RESET}"
  arch-chroot /mnt passwd $userstr

  echo -e "\n${CNT} ${BONSAI_TEXT}Configuring sudo...${BONSAI_RESET}"
  variable="%wheel ALL=(ALL:ALL) ALL"
  arch-chroot /mnt sed -i "/^# $variable/s/#\s*//" /etc/sudoers

  echo -e "${CNT} ${BONSAI_TEXT}Enabling services...${BONSAI_RESET}"
  arch-chroot /mnt systemctl enable NetworkManager
  arch-chroot /mnt systemctl enable ntpd.service

  echo -e "${CNT} ${BONSAI_TEXT}Copying installation files...${BONSAI_RESET}"
  cp -r ~/archinstall /mnt/home/$userstr
  chmod 777 /mnt/home/$userstr/archinstall

  umount -l /mnt

  show_section "Installation Complete! 🌱"

  echo -e "${COK} ${BONSAI_GREEN}System installation finished successfully!${BONSAI_RESET}"
  echo -e "${CNT} ${BONSAI_TEXT}Choose an action:${BONSAI_RESET}\n"
  echo -e "  ${BONSAI_GREEN}[1]${BONSAI_RESET} ${BONSAI_TEXT}Shutdown${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[2]${BONSAI_RESET} ${BONSAI_TEXT}Reboot${BONSAI_RESET}"

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select action [1-2]: ${BONSAI_RESET})" action_choice

  case $action_choice in
    1) shutdown now ;;
    2) reboot ;;
    *) echo -e "${CWR} ${BONSAI_YELLOW}No action taken${BONSAI_RESET}" ;;
  esac
}

function install_hyprland() {
  show_bonsai_header
  show_section "Hyprland Installation"

  echo -e "${CNT} ${BONSAI_TEXT}Preparing to install Hyprland and tools...${BONSAI_RESET}\n"

  if ! command -v yay &> /dev/null; then
    echo -e "${CNT} ${BONSAI_TEXT}Installing yay AUR helper...${BONSAI_RESET}"
    git clone https://aur.archlinux.org/yay.git
    pushd yay
    makepkg -srci --noconfirm
    popd
    rm -rf yay
  fi

  echo -e "${CNT} ${BONSAI_TEXT}Updating system...${BONSAI_RESET}"
  yay --noconfirm -Syu

  echo -e "\n${CNT} ${BONSAI_TEXT}Removing conflicting packages...${BONSAI_RESET}"
  for SOFTWR in ${uninstall_stage[@]}; do
    uninstall_software $SOFTWR
  done

  echo -e "\n${CNT} ${BONSAI_TEXT}Installing Pipewire audio system...${BONSAI_RESET}"
  for SOFTWR in ${piperwire_stage[@]}; do
    install_software $SOFTWR
  done

  echo -e "\n${CNT} ${BONSAI_TEXT}Installing Hyprland components...${BONSAI_RESET}"
  for SOFTWR in ${hypr_base_stage[@]}; do
    install_software $SOFTWR
  done

  # Nvidia detection and setup
  if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    ISNVIDIA=true
  else
    ISNVIDIA=false
  fi

  if [[ "$ISNVIDIA" == true ]]; then
    show_section "NVIDIA GPU Configuration"

    echo -e "${CNT} ${BONSAI_TEXT}NVIDIA GPU detected, installing drivers...${BONSAI_RESET}"

    for SOFTWR in ${uninstall_nvidia_stage[@]}; do
      uninstall_software $SOFTWR
    done

    for SOFTWR in ${nvidia_stage[@]}; do
      install_software $SOFTWR
    done

    # Configure mkinitcpio for Nvidia
    if grep -qE '^MODULES=.*nvidia. *nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
      echo -e "${COK} ${BONSAI_TEXT}Nvidia modules already configured${BONSAI_RESET}"
    else
      sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
      echo -e "${COK} ${BONSAI_TEXT}Nvidia modules added to mkinitcpio.conf${BONSAI_RESET}"
    fi

    sudo mkinitcpio -P 2>&1 | tee -a "$INSTLOG"

    # Configure modprobe
    NVEA="/etc/modprobe.d/nvidia.conf"
    if [ -f "$NVEA" ]; then
      echo -e "${COK} ${BONSAI_TEXT}Nvidia modeset already configured${BONSAI_RESET}"
    else
      echo -e "${CNT} ${BONSAI_TEXT}Adding Nvidia modeset configuration...${BONSAI_RESET}"
      sudo echo -e "options nvidia_drm modeset=1 fbdev=1" | sudo tee -a /etc/modprobe.d/nvidia.conf 2>&1 | tee -a "$INSTLOG"
    fi
  fi

  echo -e "\n${CNT} ${BONSAI_TEXT}Installing development tools and applications...${BONSAI_RESET}"
  echo -e "${BONSAI_MUTED}This will take some time, please be patient...${BONSAI_RESET}\n"

  for SOFTWR in ${tools_stage[@]}; do
    install_software $SOFTWR
  done

  echo -e "\n${CNT} ${BONSAI_TEXT}Enabling services...${BONSAI_RESET}"
  sudo systemctl enable sddm
  sudo systemctl enable bluetooth.service

  show_section "Shell Configuration"

  echo -e "${CNT} ${BONSAI_TEXT}Installing Oh My Zsh...${BONSAI_RESET}"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echo -e "${CNT} ${BONSAI_TEXT}Installing Powerlevel10k theme...${BONSAI_RESET}"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  echo -e "${CNT} ${BONSAI_TEXT}Installing pyenv...${BONSAI_RESET}"
  curl https://pyenv.run | bash
  git clone https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update

  echo -e "\n${COK} ${BONSAI_GREEN}Hyprland installation complete!${BONSAI_RESET}"
}

function install_software() {
  echo -en "${CNT} ${BONSAI_TEXT}Installing ${BONSAI_GREEN}$1${BONSAI_RESET} "
  yay -S --noconfirm $1 &>> $INSTLOG &
  show_progress $!
  echo -e "\e[1A\e[K${COK} ${BONSAI_GREEN}$1${BONSAI_TEXT} installed${BONSAI_RESET}"
}

function uninstall_software() {
  local pkg="$1"
  if yay -Qi "$pkg" &>> /dev/null; then
    echo -en "${CNT} ${BONSAI_TEXT}Removing ${BONSAI_YELLOW}$pkg${BONSAI_RESET} "
    yay -R --noconfirm $pkg &>> $INSTLOG &
    show_progress $!
  else
    echo -e "${CNT} ${BONSAI_MUTED}$pkg not installed, skipping${BONSAI_RESET}"
  fi
}

function restore_dotfiles() {
  show_bonsai_header
  show_section "Dotfiles Restoration"

  echo -e "${CNT} ${BONSAI_TEXT}Restoring configuration files...${BONSAI_RESET}\n"

  # Check for secrets
  if ls -la ~/ | grep -iqE git-crypt-key; then
    echo -e "${CNT} ${BONSAI_TEXT}Unlocking secrets with git-crypt...${BONSAI_RESET}"
    pushd ~/archinstall/
    git-crypt unlock ../git-crypt-key
    popd

    echo -e "${CNT} ${BONSAI_TEXT}Restoring Git configuration...${BONSAI_RESET}"
    rm -rf ~/.gitconfig
    stow -v 1 -t ~/ -d ~/archinstall/secrets/dotfiles/home gitconfig
  else
    echo -e "${CNT} ${BONSAI_MUTED}No git-crypt-key found, skipping secrets${BONSAI_RESET}"
  fi

  # VS Code
  echo -e "${CNT} ${BONSAI_TEXT}Configuring VS Code...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config code

  # BTOP
  echo -e "${CNT} ${BONSAI_TEXT}Configuring BTOP...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config btop

  # Zathura
  echo -e "${CNT} ${BONSAI_TEXT}Configuring Zathura...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config zathura

  # Hyfetch
  echo -e "${CNT} ${BONSAI_TEXT}Configuring Hyfetch...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config hyfetch

  # LazyGit
  echo -e "${CNT} ${BONSAI_TEXT}Configuring LazyGit...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config lazygit

  # Hyprland
  echo -e "\n${CNT} ${BONSAI_TEXT}Configuring Hyprland...${BONSAI_RESET}"
  rm -rf ~/.config/hypr

  echo -e "${CNT} ${BONSAI_TEXT}Select device type:${BONSAI_RESET}\n"
  echo -e "  ${BONSAI_GREEN}[1]${BONSAI_RESET} ${BONSAI_TEXT}Desktop${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[2]${BONSAI_RESET} ${BONSAI_TEXT}Laptop${BONSAI_RESET}"

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select device [1-2]: ${BONSAI_RESET})" device_choice

  case "$device_choice" in
    1)
      stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config/hypr desktop
      chmod u+x ~/archinstall/dotfiles/config/hypr/desktop/.config/hypr/wallpaper.sh
      echo -e "${COK} ${BONSAI_TEXT}Desktop configuration applied${BONSAI_RESET}"
      ;;
    2)
      stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config/hypr laptop
      chmod u+x ~/archinstall/dotfiles/config/hypr/laptop/.config/hypr/wallpaper.sh
      echo -e "${COK} ${BONSAI_TEXT}Laptop configuration applied${BONSAI_RESET}"
      ;;
    *)
      echo -e "${CER} ${BONSAI_RED}Invalid selection${BONSAI_RESET}"
      ;;
  esac

  # Continue with other dotfiles...
  echo -e "\n${CNT} ${BONSAI_TEXT}Configuring remaining applications...${BONSAI_RESET}"

  # Waybar
  rm -rf ~/.config/waybar
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config waybar

  # Rofi
  rm -rf ~/.config/rofi
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config rofi

  # Oh My Zsh plugins
  echo -e "${CNT} ${BONSAI_TEXT}Installing ZSH plugins...${BONSAI_RESET}"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ~/archinstall/catppuccin-zsh-syntax-highlighting
  git clone --depth=1 https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode

  # FZF-Git
  echo -e "${CNT} ${BONSAI_TEXT}Installing FZF-Git...${BONSAI_RESET}"
  git clone https://github.com/junegunn/fzf-git.sh.git ~/archinstall/fzf-git

  # TMUX
  echo -e "${CNT} ${BONSAI_TEXT}Configuring TMUX...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/home tmux
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  # Shell configuration
  echo -e "${CNT} ${BONSAI_TEXT}Configuring shell...${BONSAI_RESET}"
  rm -rf ~/.zshrc
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/home zshrc
  rm -rf ~/.p10k.zsh
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/home p10k

  # Themes and icons
  echo -e "${CNT} ${BONSAI_TEXT}Installing themes and icons...${BONSAI_RESET}"
  rm -rf ~/.themes
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/home themes
  rm -rf ~/.icons
  cp -r ~/archinstall/dotfiles/home/icons/.icons ~/
  unzip ~/.icons/WhiteSur.zip -d ~/.icons/

  # Kitty
  echo -e "${CNT} ${BONSAI_TEXT}Configuring Kitty terminal...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config/ kitty

  # Mutt email client
  echo -e "${CNT} ${BONSAI_TEXT}Configuring Mutt email client...${BONSAI_RESET}"
  mkdir -p ~/.cache/mutt/{headers,messages}
  mkdir -p ~/.config/mutt/accounts
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config mutt
  chmod +x ~/.config/mutt/scripts/*.sh

  # Calcurse calendar configuration
  echo -e "${COK} Setting up calcurse configuration..."
  mkdir -p ~/.local/share/calcurse
  mkdir -p ~/.config/calcurse/{hooks,caldav}
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config calcurse
  chmod +x ~/.config/calcurse/scripts/*.sh
  # Enable notification service (but don't start it yet)
  systemctl --user enable calcurse-notify.service 2> /dev/null || true

  # Initialize password store if not exists
  if [ ! -d ~/.password-store ]; then
    echo -e "${CNT} ${BONSAI_TEXT}Initializing password store...${BONSAI_RESET}"
    gpg_key=$(gpg --list-secret-keys --keyid-format LONG 2> /dev/null | grep sec | head -1 | awk '{print $2}' | cut -d'/' -f2)
    if [ -n "$gpg_key" ]; then
      pass init "$gpg_key"
    else
      echo -e "${CWR} ${BONSAI_YELLOW}No GPG key found. Run 'gpg --gen-key' to create one${BONSAI_RESET}"
    fi
  fi

  # Bat
  echo -e "${CNT} ${BONSAI_TEXT}Configuring Bat...${BONSAI_RESET}"
  mkdir -p "$(bat --config-dir)/themes"
  wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
  bat cache --build

  # BONSAIVIM
  echo -e "\n${CNT} ${BONSAI_TEXT}Installing BONSAIVIM...${BONSAI_RESET}"
  if [ ! -d "$HOME/BONSAIVIM" ]; then
    echo -e "${CNT} ${BONSAI_TEXT}Cloning BONSAIVIM repository...${BONSAI_RESET}"
    git clone https://github.com/Zwelckovich/BONSAIVIM.git ~/BONSAIVIM
  else
    echo -e "${CNT} ${BONSAI_TEXT}Updating BONSAIVIM...${BONSAI_RESET}"
    pushd ~/BONSAIVIM
    git pull
    popd
  fi

  pushd ~/BONSAIVIM
  chmod +x symlink_nvim_clean.sh
  ./symlink_nvim_clean.sh
  popd

  echo -e "\n${COK} ${BONSAI_GREEN}Dotfiles restoration complete!${BONSAI_RESET}"
}

function update_grub_sddm() {
  show_bonsai_header
  show_section "GRUB & SDDM Theme Update"

  echo -e "${CNT} ${BONSAI_TEXT}Installing BONSAI themes...${BONSAI_RESET}\n"

  # SDDM
  echo -e "${CNT} ${BONSAI_TEXT}Configuring SDDM with BONSAI theme...${BONSAI_RESET}"
  sudo cp -r ~/archinstall/dotfiles/etc/sddm.conf /etc/
  sudo cp -r ~/archinstall/dotfiles/usr/share/sddm/themes/bonsai/ /usr/share/sddm/themes/

  # GRUB
  echo -e "${CNT} ${BONSAI_TEXT}Configuring GRUB with BONSAI theme...${BONSAI_RESET}"
  sudo cp -r ~/archinstall/dotfiles/etc/default/grub /etc/default/
  sudo cp -r ~/archinstall/dotfiles/usr/share/grub/themes/* /boot/grub/themes/

  # Nvidia configuration if needed
  if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    ISNVIDIA=true
  else
    ISNVIDIA=false
  fi

  if [[ "$ISNVIDIA" == true ]]; then
    echo -e "${CNT} ${BONSAI_TEXT}Configuring GRUB for NVIDIA...${BONSAI_RESET}"

    if [ -f /etc/default/grub ]; then
      if ! sudo grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
        sudo sed -i -e 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia-drm.modeset=1"/' /etc/default/grub
        echo -e "${COK} ${BONSAI_TEXT}nvidia-drm.modeset=1 added${BONSAI_RESET}"
      fi

      if ! sudo grep -q "nvidia_drm.fbdev=1" /etc/default/grub; then
        sudo sed -i -e 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia_drm.fbdev=1"/' /etc/default/grub
        echo -e "${COK} ${BONSAI_TEXT}nvidia_drm.fbdev=1 added${BONSAI_RESET}"
      fi
    fi
  fi

  # Handle encryption configuration
  show_section "GRUB Encryption Configuration"

  echo -e "${CNT} ${BONSAI_TEXT}Is your system encrypted?${BONSAI_RESET}\n"
  echo -e "  ${BONSAI_GREEN}[1]${BONSAI_RESET} ${BONSAI_TEXT}Yes (encrypted)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[2]${BONSAI_RESET} ${BONSAI_TEXT}No (standard)${BONSAI_RESET}"

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select option [1-2]: ${BONSAI_RESET})" enc_status

  if [[ "$enc_status" == "1" ]]; then
    echo -e "\n${CNT} ${BONSAI_TEXT}Detecting encrypted partition...${BONSAI_RESET}"

    # Show available partitions
    echo -e "${BONSAI_MUTED}"
    sudo lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT
    echo -e "${BONSAI_RESET}"

    # Auto-detect LUKS partitions
    luks_parts=$(lsblk -rno NAME,FSTYPE | grep crypto_LUKS | awk '{print $1}')

    if [ ! -z "$luks_parts" ]; then
      echo -e "${COK} ${BONSAI_TEXT}Found encrypted partition: ${BONSAI_GREEN}/dev/$luks_parts${BONSAI_RESET}"
      SELECTED_PART="/dev/$luks_parts"
    else
      echo -e "${CWR} ${BONSAI_YELLOW}Could not auto-detect encrypted partition${BONSAI_RESET}"

      # Manual selection
      disks=($(lsblk -dno NAME,TYPE | grep disk | awk '{print $1}'))

      echo -e "\n${CNT} ${BONSAI_TEXT}Select disk containing encrypted partition:${BONSAI_RESET}\n"

      for i in "${!disks[@]}"; do
        local disk="${disks[$i]}"
        local size=$(lsblk -dno SIZE /dev/$disk 2> /dev/null)
        echo -e "  ${BONSAI_GREEN}[$((i + 1))]${BONSAI_RESET} ${BONSAI_TEXT}/dev/$disk${BONSAI_RESET} - ${BONSAI_MUTED}$size${BONSAI_RESET}"
      done

      echo ""
      read -p "$(echo -e ${BONSAI_YELLOW}Select disk [1-${#disks[@]}]: ${BONSAI_RESET})" disk_choice

      if [[ "$disk_choice" =~ ^[0-9]+$ ]] && [ "$disk_choice" -ge 1 ] && [ "$disk_choice" -le "${#disks[@]}" ]; then
        selected_disk="${disks[$((disk_choice - 1))]}"

        # Determine partition number
        if [[ "$selected_disk" == nvme* ]]; then
          SELECTED_PART="/dev/${selected_disk}p2"
        else
          SELECTED_PART="/dev/${selected_disk}2"
        fi
      fi
    fi

    if [ ! -z "$SELECTED_PART" ]; then
      deviceUUID=$(sudo blkid -s UUID -o value $SELECTED_PART)
      variable="GRUB_CMDLINE_LINUX="""
      variable_changed="GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${deviceUUID}:root:allow-discards\""
      sudo sed -i "/^$variable/ c$variable_changed" /etc/default/grub

      echo -e "${COK} ${BONSAI_TEXT}GRUB configured for encrypted partition${BONSAI_RESET}"
    fi
  fi

  echo -e "\n${CNT} ${BONSAI_TEXT}Regenerating GRUB configuration...${BONSAI_RESET}"
  sudo grub-mkconfig -o /boot/grub/grub.cfg

  echo -e "\n${COK} ${BONSAI_GREEN}GRUB and SDDM themes updated successfully!${BONSAI_RESET}"
}

# Main menu with BONSAI styling
function main_menu() {
  show_bonsai_header

  echo -e "${BONSAI_TEXT}Welcome to the BONSAI Arch Linux Installer${BONSAI_RESET}"
  echo -e "${BONSAI_MUTED}Enhanced installation experience with zen aesthetics${BONSAI_RESET}\n"

  echo -e "${CNT} ${BONSAI_TEXT}Select an action:${BONSAI_RESET}\n"
  echo -e "  ${BONSAI_GREEN}[1]${BONSAI_RESET} ${BONSAI_TEXT}Install Arch Linux${BONSAI_RESET} ${BONSAI_MUTED}(Base system)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[2]${BONSAI_RESET} ${BONSAI_TEXT}Install Hyprland${BONSAI_RESET} ${BONSAI_MUTED}(Desktop environment)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[3]${BONSAI_RESET} ${BONSAI_TEXT}Restore Dotfiles${BONSAI_RESET} ${BONSAI_MUTED}(Configuration files)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[4]${BONSAI_RESET} ${BONSAI_TEXT}Update GRUB/SDDM${BONSAI_RESET} ${BONSAI_MUTED}(Themes)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[5]${BONSAI_RESET} ${BONSAI_TEXT}Exit${BONSAI_RESET}"

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select option [1-5]: ${BONSAI_RESET})" menu_choice

  case $menu_choice in
    1)
      pacman_init
      btrfs_format
      base_config
      ;;
    2)
      install_hyprland
      ;;
    3)
      restore_dotfiles
      ;;
    4)
      update_grub_sddm
      ;;
    5)
      echo -e "\n${COK} ${BONSAI_GREEN}Thank you for using BONSAI installer!${BONSAI_RESET}"
      echo -e "${BONSAI_MUTED}May your system grow with purpose 🌱${BONSAI_RESET}\n"
      exit 0
      ;;
    *)
      echo -e "${CER} ${BONSAI_RED}Invalid selection${BONSAI_RESET}"
      sleep 2
      main_menu
      ;;
  esac
}

# Start the installer
main_menu

