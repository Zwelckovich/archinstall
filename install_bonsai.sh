#!/bin/bash
set -euo pipefail
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
BOOTLOADER_TYPE=""

# Distribution and kernel selection (CachyOS support)
DISTRO_TYPE="arch"              # arch or cachyos
KERNEL_TYPE="linux"             # linux, linux-cachyos, linux-cachyos-bore, etc.
KERNEL_HEADERS="linux-headers"  # Computed based on kernel selection
PARTITION1=""
PARTITION2=""
# Cached EFI system partition metadata
ESP_SRC=""
ESP_DEV=""
ESP_DISK=""
ESP_PARTNUM=""
ESP_PARTUUID=""
ESP_LABEL=""

# Track efivarfs mounts so we can clean them up after bootloader installation
EFIVARFS_HOST_MOUNTED=false
EFIVARFS_BOUND_CHROOT=false

# Absolute path to the installer root directory
SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

## Package arrays (preserved from original)
hypr_base_stage=(
  kitty                           # GPU-accelerated terminal emulator
  pamixer                         # PulseAudio command-line mixer
  pavucontrol                     # PulseAudio volume control GUI
  playerctl                       # Media player controller
  rofi-wayland                    # Application launcher for Wayland
  waybar                          # Status bar for Wayland compositors
  sddm                            # Display manager
  hyprcursor                      # Hyprland cursor theme manager
  hyprutils                       # Hyprland utilities library
  hypridle                        # Hyprland idle daemon
  hyprlock                        # Hyprland screen locker
  hyprland                        # Dynamic tiling Wayland compositor
  pyprland                        # Python plugin system for Hyprland
  swww                            # Animated wallpaper daemon for Wayland
  swaync                          # Notification center for Sway/Wayland
  wl-clipboard                    # Wayland clipboard utilities
  clipse                          # Clipboard manager
  adobe-source-code-pro-fonts     # Monospaced font family
  noto-fonts-emoji                # Google's emoji font
  otf-font-awesome                # Icon font
  ttf-droid                       # Android's default font family
  ttf-fira-code                   # Monospaced font with programming ligatures
  ttf-jetbrains-mono              # JetBrains monospaced font
  ttf-jetbrains-mono-nerd         # JetBrains font with extra glyphs
  qt5ct                           # Qt5 configuration tool
  qt6ct                           # Qt6 configuration tool
  catppuccin-cursors-mocha        # Catppuccin cursor theme
  nwg-look                        # GTK theme switcher for Wayland
)

pipewire_stage=(
  pipewire              # Modern multimedia framework
  wireplumber           # Session/policy manager for PipeWire
  pipewire-audio        # Audio support for PipeWire
  pipewire-alsa         # ALSA compatibility layer
  pipewire-pulse        # PulseAudio replacement compatibility
  sof-firmware          # Sound Open Firmware for Intel audio
)

tools_stage=(
  feh                             # Lightweight image viewer
  pacman-contrib                  # Contributed scripts for pacman
  npm                             # Node.js package manager
  nvm                             # Node Version Manager
  xfsprogs                        # XFS filesystem utilities
  librewolf-bin                   # Privacy-focused Firefox fork (AUR)
  firefox-hwaccel                 # VA-API hardware video decode for Firefox/LibreWolf (AUR)
  vaapi-autoconfig                # Auto-configure VA-API based on GPU (AUR)
  visual-studio-code-bin          # Microsoft's code editor
  qt5-graphicaleffects            # Qt5 graphical effects
  qt5-svg                         # Qt5 SVG support
  qt6-svg                         # Qt6 SVG support
  qt5-quickcontrols2              # Qt5 quick controls
  eza                             # Modern ls replacement (better colors/icons)
  hyfetch                         # System info with pride flags
  bfg                             # Git repository cleaner
  git-crypt                       # Transparent file encryption in git
  git-lfs                         # Git Large File Storage
  github-cli                      # GitHub command-line interface
  python                          # Python programming language
  python-pip                      # Python package installer
  python-pynvim                   # Python client for Neovim
  tk                              # Tcl/Tk GUI toolkit
  rust                            # Rust programming language
  pycharm                         # Python IDE by JetBrains
  webstorm                        # JavaScript/TypeScript IDE by JetBrains
  docker                          # Container platform
  biome                           # Fast formatter/linter for JS/TS (BONSAI preferred)
  claude-code                     # Claude AI code assistant
  shfmt                           # Shell script formatter
  stylua                          # Lua code formatter
  luacheck                        # Lua linter
  prettier                        # Code formatter for web languages
  tokei                           # Code statistics tool
  quarto-cli-bin                  # Scientific publishing system
  step                            # Certificate/key management CLI
  texlive                         # LaTeX document preparation system
  texlive-langgerman              # German language support for LaTeX
  zathura                         # Lightweight document viewer
  zathura-pdf-mupdf               # PDF support for Zathura
  meld                            # Visual diff and merge tool
  baobab                          # Disk usage analyzer
  neomutt                         # Terminal email client
  w3m                             # Text-based web browser
  lynx                            # Text-based web browser
  urlscan                         # URL extractor/launcher
  isync                           # IMAP/MailDir synchronization
  msmtp                           # SMTP client
  pass                            # Password manager
  abook                           # Address book for mutt
  calcurse                        # Calendar and scheduling app
  d2                              # Modern diagram scripting language
  ffmpeg                          # Multimedia framework
  audacity                        # Audio editor
  yt-dlp                          # YouTube downloader
  mpv                             # Media player
  ncspot                          # Spotify TUI client
  inkscape                        # Vector graphics editor
  typst                           # Modern markup-based typesetting
  tinymist                        # Typst language server
  grim                            # Wayland screenshot tool
  slurp                           # Wayland region selector
  tesseract                       # OCR engine
  tesseract-data-eng              # English language data for Tesseract
  tesseract-data-deu              # German language data for Tesseract
  blender                         # 3D creation suite
  bottom                          # System monitor (btm)
  lazygit                         # Terminal UI for git
  stow                            # Symlink farm manager (dotfiles)
  zsh                             # Z shell
  fzf                             # Fuzzy finder
  fd                              # Fast find alternative
  bat                             # Cat clone with syntax highlighting
  git-delta                       # Syntax-highlighting pager for git
  tlrc                            # Rust tldr client
  thefuck                         # Command correction tool
  zoxide                          # Smarter cd command
  reflector                       # Pacman mirror list updater
  ripgrep                         # Fast grep alternative
  procs                           # Modern ps replacement
  tre-command                     # Tree with git awareness
  unzip                           # ZIP archive extractor
  ni-visa                         # National Instruments VISA library
  expac                           # Pacman database extraction utility
  scc                             # Code counter with complexity analysis
  duf                             # Disk usage utility
  ncdu                            # NCurses disk usage analyzer
  rsync                           # Fast file transfer and sync
  dua-cli                         # Disk usage analyzer
  sox                             # Sound processing tool
  testdisk                        # Data recovery tool
  timeshift                       # System restore/snapshot utility
  downgrade                       # Downgrade packages from cache/ALA
  cifs-utils                      # CIFS/SMB filesystem utilities
  smbclient                       # Samba client
  openssh                         # SSH client and server
  file                            # File type identification
  ueberzugpp                      # Terminal image display
  chafa                           # Image to text converter
  jq                              # JSON processor
  yazi                            # Terminal file manager
  steam                           # Gaming platform
  lutris                          # Game launcher
  discord                         # Voice/chat platform
  qucs-s                          # Circuit simulator
  paraview                        # Scientific data visualization
  bluez                           # Bluetooth protocol stack
  bluez-utils                     # Bluetooth utilities
  blueman                         # Bluetooth manager
)

# NVIDIA GPU packages - Arch Linux (kernel-specific driver)
nvidia_stage_arch=(
  linux-headers                   # Kernel headers for building modules
  nvidia                          # NVIDIA proprietary driver
  nvidia-settings                 # NVIDIA driver configuration tool
  nvidia-utils                    # NVIDIA driver utilities
  libva                           # Video Acceleration API
  libva-utils                     # VA-API diagnostics (vainfo)
  libva-nvidia-driver-git         # VA-API driver for NVIDIA
  cuda                            # NVIDIA CUDA toolkit
)

# NVIDIA GPU packages - CachyOS (DKMS driver for any kernel)
nvidia_stage_cachyos=(
  nvidia-dkms                     # NVIDIA DKMS driver (works with any kernel)
  nvidia-settings                 # NVIDIA driver configuration tool
  nvidia-utils                    # NVIDIA driver utilities
  libva                           # Video Acceleration API
  libva-utils                     # VA-API diagnostics (vainfo)
  libva-nvidia-driver-git         # VA-API driver for NVIDIA
  cuda                            # NVIDIA CUDA toolkit
)

# CachyOS optimized packages (x86-64-v3 builds)
cachyos_optimized_packages=(
  mesa                            # Graphics stack (significant gaming improvement)
  mesa-utils                      # Mesa utilities
  zstd                            # Compression (faster package operations)
  zlib-ng                         # Compression library
  sqlite                          # Database (faster package queries)
  pipewire                        # Audio (lower latency)
  wireplumber                     # PipeWire session manager
)

uninstall_stage=(
  dunst                           # Lightweight notification daemon (conflicts with swaync)
  mako                            # Wayland notification daemon (conflicts with swaync)
  rofi                            # X11 version (using rofi-wayland instead)
  wallust-git                     # Outdated package to remove
)

uninstall_nvidia_stage=(
  hyprland-git                    # Git version (using stable instead)
  hyprland-nvidia                 # Old NVIDIA-patched version
  hyprland-nvidia-git             # Git version of NVIDIA patch
  hyprland-nvidia-hidpi-git       # HiDPI NVIDIA variant (outdated)
)

# BONSAI styled header
function show_bonsai_header() {
  clear
  echo -e "${BONSAI_GREEN}"
  echo "┌─────────────────────────────────────────────────────────────────────────────┐"
  echo "│                                                                             │"
  echo "│     🌱 ██████╗  ██████╗ ███╗   ██╗███████╗ █████╗ ██╗ 🌱                    │"
  echo "│        ██╔══██╗██╔═══██╗████╗  ██║██╔════╝██╔══██╗██║                       │"
  echo "│        ██████╔╝██║   ██║██╔██╗ ██║███████╗███████║██║                       │"
  echo "│        ██╔══██╗██║   ██║██║╚██╗██║╚════██║██╔══██║██║                       │"
  echo "│        ██████╔╝╚██████╔╝██║ ╚████║███████║██║  ██║██║                       │"
  echo "│        ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝                       │"
  echo "│                                                                             │"
  echo "│   █████╗ ██████╗  ██████╗██╗  ██╗    ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗ │"
  echo "│  ██╔══██╗██╔══██╗██╔════╝██║  ██║    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝ │"
  echo "│  ███████║██████╔╝██║     ███████║    ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝  │"
  echo "│  ██╔══██║██╔══██╗██║     ██╔══██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗  │"
  echo "│  ██║  ██║██║  ██║╚██████╗██║  ██║    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗ │"
  echo "│  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝ │"
  echo "│                                                                             │"
  echo -e "│                     ${BONSAI_MUTED}Minimal • Purposeful • Beautiful${BONSAI_GREEN}                        │"
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

  for i in "${!disks[@]}"; do
    local disk="${disks[$i]}"
    local size=$(lsblk -dno SIZE /dev/$disk 2> /dev/null)
    local model=$(lsblk -dno MODEL /dev/$disk 2> /dev/null | sed 's/ *$//')
    local filesystems=$(lsblk -no FSTYPE /dev/$disk 2> /dev/null | grep -v "^$" | sort -u | tr '\n' ',' | sed 's/,$//' | sed 's/,/, /g')
    [[ -z "$model" ]] && model="Unknown"
    [[ -z "$filesystems" ]] && filesystems="none"

    echo -e "  ${BONSAI_GREEN}[$((i + 1))]${BONSAI_RESET} ${BONSAI_TEXT}/dev/$disk${BONSAI_RESET} - ${BONSAI_MUTED}$size - $model${BONSAI_RESET} ${BONSAI_PURPLE}[fs: $filesystems]${BONSAI_RESET}"
  done

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select disk for installation [1-${#disks[@]}]: ${BONSAI_RESET})" disk_choice

  if [[ $disk_choice =~ ^[0-9]+$ ]] && [ "$disk_choice" -ge 1 ] && [ "$disk_choice" -le "${#disks[@]}" ]; then
    SELECTED_DISK="${disks[$((disk_choice - 1))]}"
    SELECTED_DISK_NAME="/dev/$SELECTED_DISK"

    echo -e "\n${COK} ${BONSAI_TEXT}Selected: ${BONSAI_GREEN}$SELECTED_DISK_NAME${BONSAI_RESET}"

    echo -e "\n${CNT} ${BONSAI_TEXT}Current partition layout:${BONSAI_RESET}"
    echo -e "${BONSAI_MUTED}"
    lsblk $SELECTED_DISK_NAME
    echo -e "${BONSAI_RESET}"

    echo -e "\n${CWR} ${BONSAI_YELLOW}WARNING: This will DESTROY all data on $SELECTED_DISK_NAME${BONSAI_RESET}"
    read -p "$(echo -e ${BONSAI_RED}Are you sure? [y/N]: ${BONSAI_RESET})" confirm

    if [[ $confirm != "y" && $confirm != "Y" ]]; then
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
      USE_ENCRYPTION=true
                           echo -e "${CWR} ${BONSAI_YELLOW}Invalid selection, defaulting to encrypted${BONSAI_RESET}"
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

# Bootloader selection with BONSAI styling
function select_bootloader() {
  show_section "Bootloader Selection"

  echo -e "${CNT} ${BONSAI_TEXT}Choose your bootloader:${BONSAI_RESET}\n"
  echo -e "  ${BONSAI_GREEN}[1]${BONSAI_RESET} ${BONSAI_TEXT}GRUB${BONSAI_RESET} ${BONSAI_MUTED}(Traditional, themes, dual-boot friendly)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[2]${BONSAI_RESET} ${BONSAI_TEXT}systemd-boot${BONSAI_RESET} ${BONSAI_MUTED}(Simple, fast, modern EFI-only)${BONSAI_RESET}"

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select bootloader [1-2]: ${BONSAI_RESET})" bootloader_choice

  case $bootloader_choice in
    1)
      BOOTLOADER_TYPE="grub"
                                      echo -e "\n${COK} ${BONSAI_TEXT}Bootloader: ${BONSAI_GREEN}GRUB${BONSAI_RESET}"
                                                                                                                     ;;
    2)
      BOOTLOADER_TYPE="systemd-boot"
                                      echo -e "\n${COK} ${BONSAI_TEXT}Bootloader: ${BONSAI_GREEN}systemd-boot${BONSAI_RESET}"
                                                                                                                             ;;
    *)
      BOOTLOADER_TYPE="grub"
                                      echo -e "${CWR} ${BONSAI_YELLOW}Invalid selection, defaulting to GRUB${BONSAI_RESET}"
                                                                                                                           ;;
  esac
}

# Distribution selection with BONSAI styling (Arch Linux vs CachyOS)
function select_distro() {
  show_section "Distribution Selection"

  echo -e "${CNT} ${BONSAI_TEXT}Choose your distribution:${BONSAI_RESET}\n"
  echo -e "  ${BONSAI_GREEN}[1]${BONSAI_RESET} ${BONSAI_TEXT}Arch Linux${BONSAI_RESET} ${BONSAI_MUTED}(Standard, vanilla kernel)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[2]${BONSAI_RESET} ${BONSAI_TEXT}CachyOS${BONSAI_RESET} ${BONSAI_MUTED}(Performance-optimized, gaming kernels)${BONSAI_RESET}"

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select distribution [1-2]: ${BONSAI_RESET})" distro_choice

  case $distro_choice in
    1)
      DISTRO_TYPE="arch"
      KERNEL_TYPE="linux"
      KERNEL_HEADERS="linux-headers"
      echo -e "\n${COK} ${BONSAI_TEXT}Distribution: ${BONSAI_GREEN}Arch Linux${BONSAI_RESET}"
      ;;
    2)
      DISTRO_TYPE="cachyos"
      echo -e "\n${COK} ${BONSAI_TEXT}Distribution: ${BONSAI_GREEN}CachyOS${BONSAI_RESET}"
      select_cachyos_kernel
      ;;
    *)
      DISTRO_TYPE="arch"
      KERNEL_TYPE="linux"
      KERNEL_HEADERS="linux-headers"
      echo -e "${CWR} ${BONSAI_YELLOW}Invalid selection, defaulting to Arch Linux${BONSAI_RESET}"
      ;;
  esac
}

# CachyOS kernel variant selection with BONSAI styling
function select_cachyos_kernel() {
  show_section "CachyOS Kernel Selection"

  echo -e "${CNT} ${BONSAI_TEXT}Choose your CachyOS kernel variant:${BONSAI_RESET}\n"
  echo -e "  ${BONSAI_GREEN}[1]${BONSAI_RESET} ${BONSAI_TEXT}linux-cachyos${BONSAI_RESET} ${BONSAI_MUTED}(Default, BORE scheduler - recommended)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[2]${BONSAI_RESET} ${BONSAI_TEXT}linux-cachyos-bore${BONSAI_RESET} ${BONSAI_MUTED}(BORE scheduler, explicit)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[3]${BONSAI_RESET} ${BONSAI_TEXT}linux-cachyos-lts${BONSAI_RESET} ${BONSAI_MUTED}(Long-term support, stable)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[4]${BONSAI_RESET} ${BONSAI_TEXT}linux-cachyos-hardened${BONSAI_RESET} ${BONSAI_MUTED}(Security-focused)${BONSAI_RESET}"

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select kernel [1-4]: ${BONSAI_RESET})" kernel_choice

  case $kernel_choice in
    1)
      KERNEL_TYPE="linux-cachyos"
      KERNEL_HEADERS="linux-cachyos-headers"
      ;;
    2)
      KERNEL_TYPE="linux-cachyos-bore"
      KERNEL_HEADERS="linux-cachyos-bore-headers"
      ;;
    3)
      KERNEL_TYPE="linux-cachyos-lts"
      KERNEL_HEADERS="linux-cachyos-lts-headers"
      ;;
    4)
      KERNEL_TYPE="linux-cachyos-hardened"
      KERNEL_HEADERS="linux-cachyos-hardened-headers"
      ;;
    *)
      KERNEL_TYPE="linux-cachyos"
      KERNEL_HEADERS="linux-cachyos-headers"
      echo -e "${CWR} ${BONSAI_YELLOW}Invalid selection, defaulting to linux-cachyos${BONSAI_RESET}"
      ;;
  esac

  echo -e "\n${COK} ${BONSAI_TEXT}Kernel: ${BONSAI_GREEN}$KERNEL_TYPE${BONSAI_RESET}"
}

# Helper: resolve latest CachyOS package URL dynamically
get_cachyos_pkg_url() {
  local pkg_name="$1"
  local base_url="https://mirror.cachyos.org/repo/x86_64/cachyos"
  local filename
  filename=$(curl -sL "${base_url}/" | \
    grep -oP "${pkg_name}-[0-9][^\"]*\.pkg\.tar\.zst" | \
    sort -V | tail -1)
  if [[ -n "$filename" ]]; then
    echo "${base_url}/${filename}"
  else
    echo "ERROR: Could not find latest ${pkg_name}" >&2
    return 1
  fi
}

# Configure CachyOS repositories (for chroot during fresh install)
function configure_cachyos_repos_chroot() {
  if [ "$DISTRO_TYPE" != "cachyos" ]; then
    return 0
  fi

  show_section "CachyOS Repository Configuration"

  echo -e "${CNT} ${BONSAI_TEXT}Adding CachyOS repositories...${BONSAI_RESET}"

  # Import CachyOS signing keys
  arch-chroot /mnt pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com 2>&1 | tee -a "$INSTLOG"
  arch-chroot /mnt pacman-key --lsign-key F3B607488DB35A47 2>&1 | tee -a "$INSTLOG"

  # Install cachyos-keyring and cachyos-mirrorlist from CachyOS repo
  echo -e "${CNT} ${BONSAI_TEXT}Installing CachyOS keyring and mirrorlists...${BONSAI_RESET}"
  local keyring_url mirrorlist_url v3_mirrorlist_url
  keyring_url=$(get_cachyos_pkg_url "cachyos-keyring") || true
  mirrorlist_url=$(get_cachyos_pkg_url "cachyos-mirrorlist") || true
  v3_mirrorlist_url=$(get_cachyos_pkg_url "cachyos-v3-mirrorlist") || true

  if [[ -n "$keyring_url" && -n "$mirrorlist_url" && -n "$v3_mirrorlist_url" ]]; then
    arch-chroot /mnt pacman -U --noconfirm \
      "$keyring_url" "$mirrorlist_url" "$v3_mirrorlist_url" \
      2>&1 | tee -a "$INSTLOG" || true
  else
    echo -e "${CER} ${BONSAI_RED}Failed to resolve CachyOS package URLs${BONSAI_RESET}"
    return 1
  fi

  # Add CachyOS repositories to pacman.conf (before [core] section)
  echo -e "${CNT} ${BONSAI_TEXT}Configuring pacman.conf with CachyOS repos...${BONSAI_RESET}"

  # Enable x86_64_v3 architecture for CachyOS v3 packages
  if grep -q '^Architecture\s*=\s*auto' /mnt/etc/pacman.conf; then
    sed -i 's/^Architecture\s*=\s*auto/Architecture = auto x86_64 x86_64_v3/' /mnt/etc/pacman.conf
  elif grep -q '^Architecture' /mnt/etc/pacman.conf && ! grep -q 'x86_64_v3' /mnt/etc/pacman.conf; then
    sed -i 's/^\(Architecture\s*=.*\)/\1 x86_64_v3/' /mnt/etc/pacman.conf
  fi

  # Check if CachyOS repos already added
  if ! grep -q '\[cachyos\]' /mnt/etc/pacman.conf; then
    # Insert CachyOS repos before [core]
    sed -i '/^\[core\]/i \
# CachyOS Repositories - Performance optimized packages\n\
[cachyos-v3]\n\
Include = /etc/pacman.d/cachyos-v3-mirrorlist\n\
\n\
[cachyos-core-v3]\n\
Include = /etc/pacman.d/cachyos-v3-mirrorlist\n\
\n\
[cachyos-extra-v3]\n\
Include = /etc/pacman.d/cachyos-v3-mirrorlist\n\
\n\
[cachyos]\n\
Include = /etc/pacman.d/cachyos-mirrorlist\n\
' /mnt/etc/pacman.conf
  fi

  # Sync package databases with new repos
  echo -e "${CNT} ${BONSAI_TEXT}Syncing package databases...${BONSAI_RESET}"
  arch-chroot /mnt pacman -Syy 2>&1 | tee -a "$INSTLOG"

  echo -e "${COK} ${BONSAI_TEXT}CachyOS repositories configured${BONSAI_RESET}"
}

# Configure CachyOS repositories (for running system - conversion)
function configure_cachyos_repos_running() {
  show_section "CachyOS Repository Configuration"

  echo -e "${CNT} ${BONSAI_TEXT}Adding CachyOS repositories to running system...${BONSAI_RESET}"

  # Import CachyOS signing keys
  echo -e "${CNT} ${BONSAI_TEXT}Importing CachyOS signing keys...${BONSAI_RESET}"
  sudo pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com 2>&1 | tee -a "$INSTLOG"
  sudo pacman-key --lsign-key F3B607488DB35A47 2>&1 | tee -a "$INSTLOG"

  # Install cachyos-keyring and cachyos-mirrorlist
  echo -e "${CNT} ${BONSAI_TEXT}Installing CachyOS keyring and mirrorlists...${BONSAI_RESET}"
  local keyring_url mirrorlist_url v3_mirrorlist_url
  keyring_url=$(get_cachyos_pkg_url "cachyos-keyring") || true
  mirrorlist_url=$(get_cachyos_pkg_url "cachyos-mirrorlist") || true
  v3_mirrorlist_url=$(get_cachyos_pkg_url "cachyos-v3-mirrorlist") || true

  if [[ -n "$keyring_url" && -n "$mirrorlist_url" && -n "$v3_mirrorlist_url" ]]; then
    sudo pacman -U --noconfirm \
      "$keyring_url" "$mirrorlist_url" "$v3_mirrorlist_url" \
      2>&1 | tee -a "$INSTLOG" || true
  else
    echo -e "${CER} ${BONSAI_RED}Failed to resolve CachyOS package URLs${BONSAI_RESET}"
    return 1
  fi

  # Add CachyOS repositories to pacman.conf
  echo -e "${CNT} ${BONSAI_TEXT}Configuring pacman.conf with CachyOS repos...${BONSAI_RESET}"

  # Enable x86_64_v3 architecture for CachyOS v3 packages
  if grep -q '^Architecture\s*=\s*auto' /etc/pacman.conf; then
    sudo sed -i 's/^Architecture\s*=\s*auto/Architecture = auto x86_64 x86_64_v3/' /etc/pacman.conf
  elif grep -q '^Architecture' /etc/pacman.conf && ! grep -q 'x86_64_v3' /etc/pacman.conf; then
    sudo sed -i 's/^\(Architecture\s*=.*\)/\1 x86_64_v3/' /etc/pacman.conf
  fi

  if ! grep -q '\[cachyos\]' /etc/pacman.conf; then
    sudo sed -i '/^\[core\]/i \
# CachyOS Repositories - Performance optimized packages\n\
[cachyos-v3]\n\
Include = /etc/pacman.d/cachyos-v3-mirrorlist\n\
\n\
[cachyos-core-v3]\n\
Include = /etc/pacman.d/cachyos-v3-mirrorlist\n\
\n\
[cachyos-extra-v3]\n\
Include = /etc/pacman.d/cachyos-v3-mirrorlist\n\
\n\
[cachyos]\n\
Include = /etc/pacman.d/cachyos-mirrorlist\n\
' /etc/pacman.conf
  fi

  # Sync package databases
  echo -e "${CNT} ${BONSAI_TEXT}Syncing package databases...${BONSAI_RESET}"
  sudo pacman -Syy 2>&1 | tee -a "$INSTLOG"

  echo -e "${COK} ${BONSAI_TEXT}CachyOS repositories configured${BONSAI_RESET}"
}

# Helper function to detect installed bootloader
function detect_bootloader() {
  if [ -f /boot/grub/grub.cfg ] || [ -d /boot/grub ]; then
    echo "grub"
  elif [ -f /boot/loader/loader.conf ] || command -v bootctl &> /dev/null; then
    echo "systemd-boot"
  else
    echo "none"
  fi
}

function refresh_partition_table() {
  local disk_path="$1"
  if command -v udevadm > /dev/null 2>&1; then
    udevadm settle
  fi
  partprobe "$disk_path" 2> /dev/null || true
  blockdev --rereadpt "$disk_path" 2> /dev/null || true
}

function wait_for_partitions() {
  local disk_path="$1"
  shift
  for _ in {1..10}; do
    local all_present=true
    for partition in "$@"; do
      if [[ ! -b $partition ]]; then
        all_present=false
        break
      fi
    done
    if $all_present; then
      return 0
    fi
    refresh_partition_table "$disk_path"
    sleep 1
  done
  return 1
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
  grep -q '^ILoveCandy' /etc/pacman.conf || sed -i '/^Color/a ILoveCandy' /etc/pacman.conf

  echo -e "${COK} ${BONSAI_TEXT}Pacman configured successfully${BONSAI_RESET}"
}

function optimize_mirrors() {
  show_section "Mirror Optimization"

  echo -e "${CNT} ${BONSAI_TEXT}Would you like to optimize package mirrors?${BONSAI_RESET}"
  echo -e "${BONSAI_MUTED}This helps prevent download errors like HTTP 503${BONSAI_RESET}\n"
  echo -e "  ${BONSAI_GREEN}[1]${BONSAI_RESET} ${BONSAI_TEXT}Yes, optimize mirrors (recommended)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[2]${BONSAI_RESET} ${BONSAI_TEXT}No, use current mirrorlist${BONSAI_RESET}"

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select option [1-2]: ${BONSAI_RESET})" mirror_choice

  if [[ $mirror_choice == "2" ]]; then
    echo -e "${CNT} ${BONSAI_TEXT}Using existing mirrorlist...${BONSAI_RESET}"
    return 0
  fi

  echo -e "\n${CNT} ${BONSAI_TEXT}Optimizing package mirrors for best performance...${BONSAI_RESET}"

  cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

  echo -e "${CNT} ${BONSAI_TEXT}Testing network connectivity...${BONSAI_RESET}"
  if ! ping -c 1 archlinux.org &> /dev/null; then
    echo -e "${CER} ${BONSAI_RED}No internet connection detected!${BONSAI_RESET}"
    echo -e "${CAT} ${BONSAI_YELLOW}Please check your network connection and try again.${BONSAI_RESET}"
    exit 1
  fi

  echo -e "${CNT} ${BONSAI_TEXT}Finding fastest mirrors (this may take a minute)...${BONSAI_RESET}"
  if command -v reflector &> /dev/null; then
    reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist 2> /dev/null || true
    if ! grep -q '^Server' /etc/pacman.d/mirrorlist; then
      echo -e "${CWR} ${BONSAI_YELLOW}Reflector failed, using fallback method...${BONSAI_RESET}"
      cat > /etc/pacman.d/mirrorlist << 'MIRRORS'
## Arch Linux repository mirrorlist
## Generated by BONSAI installer fallback
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch
Server = https://mirror.f4st.host/archlinux/$repo/os/$arch
Server = https://mirror.chaoticum.net/arch/$repo/os/$arch
Server = https://mirror.netcologne.de/archlinux/$repo/os/$arch
Server = https://mirror.arizona.edu/archlinux/$repo/os/$arch
Server = https://arlm.tyzoid.com/$repo/os/$arch
Server = https://mirror.pit.teraswitch.com/archlinux/$repo/os/$arch
Server = https://mirror.i3d.net/pub/archlinux/$repo/os/$arch
Server = https://mirror.ams1.nl.leaseweb.net/archlinux/$repo/os/$arch
MIRRORS
    fi
  else
    echo -e "${CWR} ${BONSAI_YELLOW}Reflector not found, installing it...${BONSAI_RESET}"
    pacman -Sy --noconfirm --needed reflector || true
    if command -v reflector &> /dev/null; then
      reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist 2> /dev/null || true
    fi
    if ! grep -q '^Server' /etc/pacman.d/mirrorlist; then
      echo -e "${CWR} ${BONSAI_YELLOW}Using fallback mirror list...${BONSAI_RESET}"
      cat > /etc/pacman.d/mirrorlist << 'MIRRORS'
## Arch Linux repository mirrorlist
## Generated by BONSAI installer fallback
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch
Server = https://mirror.f4st.host/archlinux/$repo/os/$arch
Server = https://mirror.chaoticum.net/arch/$repo/os/$arch
Server = https://mirror.netcologne.de/archlinux/$repo/os/$arch
Server = https://mirror.arizona.edu/archlinux/$repo/os/$arch
Server = https://arlm.tyzoid.com/$repo/os/$arch
Server = https://mirror.pit.teraswitch.com/archlinux/$repo/os/$arch
Server = https://mirror.i3d.net/pub/archlinux/$repo/os/$arch
Server = https://mirror.ams1.nl.leaseweb.net/archlinux/$repo/os/$arch
MIRRORS
    fi
  fi

  echo -e "${CNT} ${BONSAI_TEXT}Synchronizing package databases...${BONSAI_RESET}"
  pacman -Syy || {
    echo -e "${CER} ${BONSAI_RED}Failed to sync package databases!${BONSAI_RESET}"
    exit 1
  }

  echo -e "${COK} ${BONSAI_TEXT}Mirrors optimized successfully${BONSAI_RESET}"
}

function btrfs_format() {
  show_section "Disk Partitioning & Formatting"

  # Select disk interactively
  select_disk

  # Select encryption
  select_encryption

  echo -e "\n${CNT} ${BONSAI_TEXT}Preparing disk...${BONSAI_RESET}"

  # Unmount any mounted partitions
  umount "/dev/${SELECTED_DISK}"?* 2> /dev/null || true
  umount -l /mnt 2> /dev/null

  echo -e "${CNT} ${BONSAI_TEXT}Wiping all existing signatures from disk...${BONSAI_RESET}"
  wipefs -af "/dev/$SELECTED_DISK"
  refresh_partition_table "/dev/$SELECTED_DISK"

  echo -e "${CNT} ${BONSAI_TEXT}Creating partition layout...${BONSAI_RESET}"
  sgdisk --zap-all "/dev/$SELECTED_DISK"
  sgdisk -n 1:0:+2G -n 2:0:0 -t 1:ef00 -t 2:8300 "/dev/$SELECTED_DISK" -p
  refresh_partition_table "/dev/$SELECTED_DISK"

  # Set partition names based on disk type
  if [[ $SELECTED_DISK == nvme* || $SELECTED_DISK == mmcblk* ]]; then
    PARTITION1="/dev/${SELECTED_DISK}p1"
    PARTITION2="/dev/${SELECTED_DISK}p2"
  else
    PARTITION1="/dev/${SELECTED_DISK}1"
    PARTITION2="/dev/${SELECTED_DISK}2"
  fi

  if ! wait_for_partitions "/dev/$SELECTED_DISK" "$PARTITION1" "$PARTITION2"; then
    echo -e "${CER} ${BONSAI_RED}Kernel did not expose new partitions for ${BONSAI_YELLOW}/dev/$SELECTED_DISK${BONSAI_RED}. Reconnect the device or reboot. ${BONSAI_RESET}"
    exit 1
  fi

  echo -e "${CNT} ${BONSAI_TEXT}Formatting boot partition...${BONSAI_RESET}"
  mkfs.fat -F32 "$PARTITION1"

  if [ "$USE_ENCRYPTION" = true ]; then
    show_section "Setting Up Encryption"
    echo -e "${CWR} ${BONSAI_YELLOW}You will be prompted to enter the encryption password${BONSAI_RESET}"
    echo -e "${CNT} ${BONSAI_TEXT}Choose a strong password and remember it!${BONSAI_RESET}\n"

    cryptsetup -c aes-xts-plain64 --key-size=512 --hash=sha512 --iter-time=3000 \
      --pbkdf=pbkdf2 --use-random luksFormat --type=luks1 "$PARTITION2"

    echo -e "\n${CNT} ${BONSAI_TEXT}Opening encrypted container...${BONSAI_RESET}"
    cryptsetup luksOpen "$PARTITION2" cryptroot

    echo -e "${CNT} ${BONSAI_TEXT}Creating BTRFS filesystem...${BONSAI_RESET}"
    mkfs.btrfs -f /dev/mapper/cryptroot

    echo -e "${CNT} ${BONSAI_TEXT}Creating BTRFS subvolumes...${BONSAI_RESET}"
    mount /dev/mapper/cryptroot /mnt
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    umount /mnt

    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ /dev/mapper/cryptroot /mnt
    mkdir -p /mnt/{boot,home}
    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home /dev/mapper/cryptroot /mnt/home
  else
    echo -e "${CNT} ${BONSAI_TEXT}Creating BTRFS filesystem (non-encrypted)...${BONSAI_RESET}"
    mkfs.btrfs -f "$PARTITION2"

    echo -e "${CNT} ${BONSAI_TEXT}Creating BTRFS subvolumes...${BONSAI_RESET}"
    mount "$PARTITION2" /mnt
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    umount /mnt

    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ "$PARTITION2" /mnt
    mkdir -p /mnt/{boot,home}
    mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home "$PARTITION2" /mnt/home
  fi

  # Mount boot partition
  mount "$PARTITION1" /mnt/boot

  echo -e "${COK} ${BONSAI_TEXT}Disk preparation complete${BONSAI_RESET}"

  # Select distribution (Arch Linux or CachyOS)
  select_distro

  # Select CPU type
  select_cpu

  # Select bootloader
  select_bootloader

  # Optimize mirrors
  optimize_mirrors

  show_section "Installing Base System"

  echo -e "${CNT} ${BONSAI_TEXT}Installing Arch Linux base system...${BONSAI_RESET}"
  echo -e "${BONSAI_MUTED}This may take a while...${BONSAI_RESET}\n"

  RETRY_COUNT=0
  MAX_RETRIES=3

  while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    current_mirror=$(grep -m 1 "^Server" /etc/pacman.d/mirrorlist | awk '{print $3}')
    if [ -n "$current_mirror" ]; then
      echo -e "${CNT} ${BONSAI_TEXT}Using mirror: ${BONSAI_MUTED}$current_mirror${BONSAI_RESET}"
    fi

    case $CPU_TYPE in
      intel) pacstrap /mnt base base-devel $KERNEL_TYPE linux-firmware nano intel-ucode btrfs-progs ;;
      amd)   pacstrap /mnt base base-devel $KERNEL_TYPE linux-firmware nano amd-ucode   btrfs-progs ;;
      vm)    pacstrap /mnt base base-devel $KERNEL_TYPE linux-firmware nano             btrfs-progs ;;
    esac

    if [ $? -eq 0 ]; then
      # Configure CachyOS repositories if selected
      configure_cachyos_repos_chroot
      break
    else
      RETRY_COUNT=$((RETRY_COUNT + 1))
      if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
        echo -e "\n${CWR} ${BONSAI_YELLOW}Installation failed, retrying (attempt $((RETRY_COUNT + 1))/$MAX_RETRIES)...${BONSAI_RESET}"
        pacman -Syy
      fi
    fi
  done

  if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo -e "\n${CER} ${BONSAI_RED}Failed to install base system after $MAX_RETRIES attempts!${BONSAI_RESET}"
    exit 1
  fi

  if [ ! -f /mnt/bin/bash ]; then
    echo -e "\n${CER} ${BONSAI_RED}Base system installation incomplete!${BONSAI_RESET}"
    exit 1
  fi

  echo -e "\n${CNT} ${BONSAI_TEXT}Generating fstab...${BONSAI_RESET}"
  genfstab -U /mnt >> /mnt/etc/fstab

  echo -e "${COK} ${BONSAI_TEXT}Base system installed successfully${BONSAI_RESET}"
}

function base_config() {
  show_bonsai_header
  show_section "System Configuration"

  if [ ! -f /mnt/bin/bash ] || [ ! -d /mnt/etc ]; then
    echo -e "${CER} ${BONSAI_RED}Base system not found in /mnt!${BONSAI_RESET}"
    exit 1
  fi

  echo -e "${CNT} ${BONSAI_TEXT}Please provide system information:${BONSAI_RESET}\n"

  while true; do
    read -rp "$(echo -e ${BONSAI_YELLOW}Enter username: ${BONSAI_RESET})" userstr
    if [[ -z $userstr ]]; then
      echo -e "${CER} ${BONSAI_RED}Username cannot be empty.${BONSAI_RESET}"
      continue
    fi
    if [[ ! $userstr =~ ^[a-z_][a-z0-9_-]*$ ]] || [ "${#userstr}" -gt 32 ]; then
      echo -e "${CER} ${BONSAI_RED}Invalid username. Use lowercase letters, numbers, underscores, or dashes (max 32).${BONSAI_RESET}"
      continue
    fi
    break
  done

  while true; do
    read -rp "$(echo -e ${BONSAI_YELLOW}Enter hostname: ${BONSAI_RESET})" hoststr
    hoststr=${hoststr,,}
    if [[ -z $hoststr ]]; then
      echo -e "${CER} ${BONSAI_RED}Hostname cannot be empty.${BONSAI_RESET}"
      continue
    fi
    if [ "${#hoststr}" -gt 253 ] || [[ ! $hoststr =~ ^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?(\.[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?)*$ ]]; then
      echo -e "${CER} ${BONSAI_RED}Invalid hostname. Use lowercase letters, numbers, and dashes.${BONSAI_RESET}"
      continue
    fi
    break
  done

  echo -e "\n${CNT} ${BONSAI_TEXT}Configuring timezone...${BONSAI_RESET}"
  arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime || {
    echo -e "${CER} ${BONSAI_RED}Failed to configure timezone!${BONSAI_RESET}"
    exit 1
  }
  arch-chroot /mnt hwclock --systohc

  echo -e "${CNT} ${BONSAI_TEXT}Configuring locale...${BONSAI_RESET}"
  variable="en_US.UTF-8 UTF-8"
  arch-chroot /mnt sed -i "s/^[#[:space:]]*${variable}/${variable}/" /etc/locale.gen
  if ! arch-chroot /mnt locale-gen; then
    echo -e "${CER} ${BONSAI_RED}Failed to generate locales!${BONSAI_RESET}"
    exit 1
  fi
  if ! arch-chroot /mnt locale -a | grep -qi '^en_US\.utf8$'; then
    echo -e "${CER} ${BONSAI_RED}Locale en_US.UTF-8 not generated correctly!${BONSAI_RESET}"
    exit 1
  fi
  arch-chroot /mnt tee /etc/locale.conf > /dev/null <<< 'LANG=en_US.UTF-8'
  arch-chroot /mnt tee /etc/vconsole.conf > /dev/null <<< 'KEYMAP=de-latin1-nodeadkeys'

  echo -e "${CNT} ${BONSAI_TEXT}Setting hostname...${BONSAI_RESET}"
  arch-chroot /mnt tee /etc/hostname > /dev/null <<< "$hoststr"
  arch-chroot /mnt tee /etc/hosts > /dev/null << EOF
127.0.0.1 localhost
::1 localhost
127.0.1.1 ${hoststr}.localdomain ${hoststr}
EOF

  show_section "Root Password"
  echo -e "${CWR} ${BONSAI_YELLOW}Please set the root password:${BONSAI_RESET}"
  arch-chroot /mnt passwd

  echo -e "\n${CNT} ${BONSAI_TEXT}Configuring pacman...${BONSAI_RESET}"
  variable="Color"
  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/pacman.conf
  variable="ParallelDownloads = 5"
  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/pacman.conf
  arch-chroot /mnt bash -c "grep -q '^ILoveCandy' /etc/pacman.conf || sed -i '/^Color/a ILoveCandy' /etc/pacman.conf"
  arch-chroot /mnt pacman-key --init
  arch-chroot /mnt pacman-key --populate archlinux

  echo -e "${CNT} ${BONSAI_TEXT}Installing essential packages...${BONSAI_RESET}"
  arch-chroot /mnt pacman -Syy
  arch-chroot /mnt pacman --noconfirm -S grub grub-btrfs efibootmgr base-devel $KERNEL_HEADERS networkmanager network-manager-applet wpa_supplicant dialog os-prober mtools dosfstools reflector git ntfs-3g xdg-utils xdg-user-dirs neovim vim vi wget iwd ntp archlinux-keyring bash-completion
  arch-chroot /mnt pacman --noconfirm -S broadcom-wl-dkms || true

  echo -e "${CNT} ${BONSAI_TEXT}Configuring initramfs...${BONSAI_RESET}"
  variable="MODULES=()"
  variable_changed="MODULES=(btrfs)"
  arch-chroot /mnt sed -i "/^$variable/ c$variable_changed" /etc/mkinitcpio.conf

  if [ "$USE_ENCRYPTION" = true ]; then
    variable="HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)"
    variable_changed="HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)"
    arch-chroot /mnt sed -i "/^$variable/ c$variable_changed" /etc/mkinitcpio.conf
  fi

  arch-chroot /mnt mkinitcpio -p $KERNEL_TYPE

  show_section "Bootloader Configuration"

  # ---------- FIXED: robust GRUB/systemd-boot setup uses findmnt and cryptsetup ----------
  # Helper to derive kernel/root options from what's actually mounted under /mnt
  derive_kernel_opts() {
    local root_src root_dev mapname luks_part luks_uuid root_uuid
    root_src=$(findmnt -no SOURCE /mnt)

    # When mounting BTRFS subvolumes, findmnt may append "[/@]". Strip any suffix so
    # the resulting path can be passed to blkid/cryptsetup.
    root_dev="${root_src%%\[*}"

    # Normalise UUID=/LABEL= style sources back into concrete device nodes.
    case "$root_dev" in
      UUID=*)
        root_dev="$(blkid -U "${root_dev#UUID=}" 2> /dev/null)"
        ;;
      LABEL=*)
        root_dev="$(blkid -L "${root_dev#LABEL=}" 2> /dev/null)"
        ;;
    esac

    if [[ -z "$root_dev" ]]; then
      root_dev="${root_src%%\[*}"
    fi

    if [[ "$root_dev" == /dev/mapper/* ]]; then
      mapname="${root_dev#/dev/mapper/}"
      if [[ -z "$mapname" ]]; then
        mapname="cryptroot"
      fi
      # NOTE: The mapper name must remain "cryptroot" to match hooks and tests.
      # root=/dev/mapper/cryptroot
      # cryptsetup status prefers the map name (without /dev/mapper/).
      luks_part=$(cryptsetup status "$mapname" 2> /dev/null | awk '/device:/ {print $2}')
      if [[ -z "$luks_part" ]]; then
        # Fallback to lsblk if cryptsetup status is unavailable.
        luks_part="/dev/$(lsblk -no PKNAME "$root_dev" | head -n1)"
      fi
      luks_uuid=$(blkid -s UUID -o value "$luks_part" 2> /dev/null)
      if [[ -n "$luks_uuid" ]]; then
        echo "cryptdevice=UUID=$luks_uuid:cryptroot root=/dev/mapper/$mapname rootflags=subvol=@ rw quiet"
      else
        echo "cryptdevice=$luks_part:cryptroot root=/dev/mapper/$mapname rootflags=subvol=@ rw quiet"
      fi
    else
      # Attempt to read the filesystem UUID from the concrete device. If that fails,
      # fall back to findmnt's UUID field or (worst case) the raw device path.
      root_uuid=$(blkid -s UUID -o value "$root_dev" 2> /dev/null)
      if [[ -z "$root_uuid" ]]; then
        root_uuid=$(findmnt -no UUID /mnt 2> /dev/null)
      fi

      if [[ -n "$root_uuid" ]]; then
        echo "root=UUID=$root_uuid rootflags=subvol=@ rw quiet"
      else
        echo "root=$root_dev rootflags=subvol=@ rw quiet"
      fi
    fi
  }

  resolve_esp_context() {
    local mount_point="${1:-/mnt/boot}"
    ESP_SRC=$(findmnt -no SOURCE "$mount_point" 2> /dev/null)
    if [[ -z "$ESP_SRC" ]]; then
      echo -e "${CER} ${BONSAI_RED}Unable to determine the source device for ${BONSAI_YELLOW}$mount_point${BONSAI_RED}.${BONSAI_RESET}"
      return 1
    fi

    local esp_fstype
    esp_fstype=$(findmnt -no FSTYPE "$mount_point" 2> /dev/null)
    if [[ -n "$esp_fstype" && "$esp_fstype" != "vfat" && "$esp_fstype" != "fat" && "$esp_fstype" != "msdos" ]]; then
      echo -e "${CWR} ${BONSAI_YELLOW}EFI system partition at ${BONSAI_YELLOW}$mount_point${BONSAI_YELLOW} is ${esp_fstype}; expected FAT32.${BONSAI_RESET}"
    fi

    case "$ESP_SRC" in
      UUID=*)
        ESP_DEV=$(blkid -U "${ESP_SRC#UUID=}" 2> /dev/null)
        ;;
      PARTUUID=*)
        ESP_DEV=$(blkid -t PARTUUID="${ESP_SRC#PARTUUID=}" -o device 2> /dev/null | head -n1)
        ;;
      LABEL=*)
        ESP_DEV=$(blkid -L "${ESP_SRC#LABEL=}" 2> /dev/null)
        ;;
      /dev/*)
        ESP_DEV=$(readlink -f "$ESP_SRC" 2> /dev/null)
        if [[ -z "$ESP_DEV" ]]; then
          ESP_DEV="$ESP_SRC"
        fi
        ;;
      *)
        ESP_DEV=$(readlink -f "$ESP_SRC" 2> /dev/null)
        ;;
    esac

    if [[ -z "$ESP_DEV" || ! -b "$ESP_DEV" ]]; then
      echo -e "${CER} ${BONSAI_RED}Unable to resolve ${BONSAI_YELLOW}$ESP_SRC${BONSAI_RED} to a block device.${BONSAI_RESET}"
      return 1
    fi

    local pkname
    pkname=$(lsblk -no PKNAME "$ESP_DEV" 2> /dev/null | head -n1)
    if [[ -z "$pkname" ]]; then
      pkname=$(lsblk -no NAME -s "$ESP_DEV" 2> /dev/null | tail -n1)
    fi
    if [[ -z "$pkname" ]]; then
      echo -e "${CER} ${BONSAI_RED}Unable to determine parent disk for ${BONSAI_YELLOW}$ESP_DEV${BONSAI_RED}.${BONSAI_RESET}"
      return 1
    fi
    ESP_DISK="/dev/$pkname"

    ESP_PARTNUM=$(lsblk -no PARTNUM "$ESP_DEV" 2> /dev/null | head -n1)
    if [[ -z "$ESP_PARTNUM" ]]; then
      local sysfs_part="/sys/class/block/$(basename "$ESP_DEV")/partition"
      if [[ -r "$sysfs_part" ]]; then
        ESP_PARTNUM=$(cat "$sysfs_part")
      fi
    fi
    if [[ -z "$ESP_PARTNUM" ]]; then
      ESP_PARTNUM=$(basename "$ESP_DEV" | sed -E 's/.*[^0-9]([0-9]+)$/\1/')
    fi
    if [[ -z "$ESP_PARTNUM" ]]; then
      echo -e "${CER} ${BONSAI_RED}Unable to determine EFI System Partition number for ${BONSAI_YELLOW}$ESP_DEV${BONSAI_RED}.${BONSAI_RESET}"
      return 1
    fi

    ESP_PARTUUID=$(blkid -s PARTUUID -o value "$ESP_DEV" 2> /dev/null || true)
    ESP_LABEL=$(blkid -s LABEL -o value "$ESP_DEV" 2> /dev/null || true)
    return 0
  }

  register_efi_entry() {
    local label="$1"
    local loader="$2"
    local create_args=(--create --disk "$ESP_DISK" --part "$ESP_PARTNUM" --label "$label" --loader "$loader")

    local chroot_output
    if command -v arch-chroot > /dev/null 2>&1; then
      if chroot_output=$(arch-chroot /mnt efibootmgr "${create_args[@]}" 2>&1); then
        echo -e "${COK} ${BONSAI_TEXT}${label} EFI entry registered successfully via target environment.${BONSAI_RESET}"
        return 0
      fi
      echo -e "${CWR} ${BONSAI_YELLOW}Target system could not register ${label} automatically. Fallback to live environment...${BONSAI_RESET}"
      if [[ -n "$chroot_output" ]]; then
        echo "$chroot_output" | sed 's/^/    /'
      fi
    fi

    if command -v efibootmgr > /dev/null 2>&1; then
      local host_output
      if host_output=$(efibootmgr "${create_args[@]}" 2>&1); then
        echo -e "${COK} ${BONSAI_TEXT}${label} EFI entry registered via live environment fallback.${BONSAI_RESET}"
        return 0
      fi
      echo -e "${CER} ${BONSAI_RED}Live environment failed to register ${label}.${BONSAI_RESET}"
      if [[ -n "$host_output" ]]; then
        echo "$host_output" | sed 's/^/    /'
      fi
    else
      echo -e "${CER} ${BONSAI_RED}efibootmgr is not available in the live environment for manual EFI entry registration.${BONSAI_RESET}"
    fi

    if [[ -n "$ESP_PARTUUID" ]]; then
      echo -e "${CAT} ${BONSAI_YELLOW}Manual fallback: efibootmgr --create --disk ${ESP_DISK} --part ${ESP_PARTNUM} --label "${label}" --loader "${loader}"${BONSAI_RESET}"
    fi
    return 1
  }

  verify_efi_entry_targets_esp() {
    local description="$1"
    local output="$2"
    if [[ -z "$ESP_PARTUUID" || -z "$output" ]]; then
      return 0
    fi
    local uppercase_partuuid
    uppercase_partuuid="${ESP_PARTUUID^^}"
    if grep -qi "GPT,${uppercase_partuuid}" <<< "$output"; then
      echo -e "${COK} ${BONSAI_TEXT}${description} entry targets ESP PARTUUID ${BONSAI_YELLOW}${ESP_PARTUUID}${BONSAI_TEXT}.${BONSAI_RESET}"
    else
      echo -e "${CWR} ${BONSAI_YELLOW}${description} entry does not reference ESP PARTUUID ${BONSAI_YELLOW}${ESP_PARTUUID}${BONSAI_YELLOW}. Verify firmware configuration manually.${BONSAI_RESET}"
    fi
  }

  ensure_efivarfs_accessible() {
    local host_efivars="/sys/firmware/efi/efivars"
    local chroot_efivars="/mnt/sys/firmware/efi/efivars"

    if [ ! -d /sys/firmware/efi ]; then
      echo -e "${CER} ${BONSAI_RED}UEFI firmware interface not detected. Cannot configure boot entries.${BONSAI_RESET}"
      return 1
    fi

    if [ ! -d "$host_efivars" ]; then
      echo -e "${CER} ${BONSAI_RED}efivarfs is unavailable at ${BONSAI_YELLOW}$host_efivars${BONSAI_RED}.${BONSAI_RESET}"
      echo -e "${CAT} ${BONSAI_YELLOW}Ensure the system was booted in UEFI mode before running the installer.${BONSAI_RESET}"
      return 1
    fi

    if ! mountpoint -q "$host_efivars"; then
      echo -e "${CNT} ${BONSAI_TEXT}Mounting efivarfs for firmware access...${BONSAI_RESET}"
      if ! mount -t efivarfs efivarfs "$host_efivars"; then
        echo -e "${CER} ${BONSAI_RED}Failed to mount efivarfs at ${BONSAI_YELLOW}$host_efivars${BONSAI_RED}.${BONSAI_RESET}"
        return 1
      fi
      EFIVARFS_HOST_MOUNTED=true
    fi

    mkdir -p /mnt/sys/firmware/efi
    mkdir -p "$chroot_efivars"
    if ! mountpoint -q "$chroot_efivars"; then
      echo -e "${CNT} ${BONSAI_TEXT}Binding efivarfs into the chroot environment...${BONSAI_RESET}"
      if ! mount --bind "$host_efivars" "$chroot_efivars"; then
        echo -e "${CER} ${BONSAI_RED}Failed to bind-mount efivarfs for the chroot.${BONSAI_RESET}"
        return 1
      fi
      EFIVARFS_BOUND_CHROOT=true
    fi

    return 0
  }

  # Function to install GRUB bootloader (uses derived opts)
  install_grub() {
    echo -e "${CNT} ${BONSAI_TEXT}Installing GRUB bootloader...${BONSAI_RESET}"

    if ! arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB; then
      echo -e "${CER} ${BONSAI_RED}Failed to install GRUB to the EFI system partition.${BONSAI_RESET}"
      return 1
    fi

    local grub_args
    grub_args="$(derive_kernel_opts)"

    # Keep quiet/loglevel, append derived root/crypt opts
    if arch-chroot /mnt grep -q '^GRUB_CMDLINE_LINUX_DEFAULT=' /etc/default/grub; then
      arch-chroot /mnt sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet ${grub_args}\"|" /etc/default/grub
    else
      arch-chroot /mnt bash -c "echo 'GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet ${grub_args}\"' >> /etc/default/grub"
    fi

    if arch-chroot /mnt grep -q '^#\?GRUB_DISABLE_OS_PROBER=' /etc/default/grub; then
      arch-chroot /mnt sed -i 's|^#\?GRUB_DISABLE_OS_PROBER=.*|GRUB_DISABLE_OS_PROBER=false|' /etc/default/grub
    else
      arch-chroot /mnt bash -c "echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub"
    fi

    if ! arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg; then
      echo -e "${CER} ${BONSAI_RED}Failed to generate GRUB configuration file.${BONSAI_RESET}"
      return 1
    fi

    if ! resolve_esp_context "/mnt/boot"; then
      return 1
    fi

    arch-chroot /mnt mkdir -p /boot/EFI/BOOT
    if [ -f /mnt/boot/EFI/GRUB/grubx64.efi ]; then
      arch-chroot /mnt cp -f /boot/EFI/GRUB/grubx64.efi /boot/EFI/BOOT/BOOTX64.EFI || true
    fi

    local grub_entry_label="BONSAI Linux (GRUB)"
    local grub_loader='\\EFI\\GRUB\\grubx64.efi'
    if arch-chroot /mnt efibootmgr | grep -E "GRUB|${grub_entry_label}|Arch" > /dev/null 2>&1; then
      echo -e "${COK} ${BONSAI_TEXT}Detected existing EFI entry for GRUB${BONSAI_RESET}"
    else
      echo -e "${CWR} ${BONSAI_YELLOW}EFI entry for GRUB not detected. Attempting registration...${BONSAI_RESET}"
      if ! register_efi_entry "$grub_entry_label" "$grub_loader"; then
        echo -e "${CER} ${BONSAI_RED}Failed to ensure EFI entry for GRUB.${BONSAI_RESET}"
        return 1
      fi
    fi

    if ! arch-chroot /mnt efibootmgr | grep -E "GRUB|${grub_entry_label}" > /dev/null 2>&1; then
      echo -e "${CWR} ${BONSAI_YELLOW}WARNING: GRUB entry is still absent. Verify firmware configuration manually.${BONSAI_RESET}"
    fi

    echo -e "${COK} ${BONSAI_TEXT}GRUB installed successfully${BONSAI_RESET}"
    return 0
  }

  # Function to install systemd-boot (robust root/ESP detection)
  install_systemd_boot() {
    echo -e "${CNT} ${BONSAI_TEXT}Installing systemd-boot...${BONSAI_RESET}"

    local bootctl_args=(install --esp-path=/boot --boot-path=/boot --make-entry=yes)
    local bootctl_no_vars_args=(install --esp-path=/boot --boot-path=/boot --no-variables)

    if ! arch-chroot /mnt bootctl "${bootctl_args[@]}"; then
      echo -e "${CWR} ${BONSAI_YELLOW}bootctl could not update firmware variables automatically. Retrying without writing to NVRAM...${BONSAI_RESET}"

      if ! arch-chroot /mnt bootctl "${bootctl_no_vars_args[@]}"; then
        echo -e "${CER} ${BONSAI_RED}Failed to install systemd-boot to /boot.${BONSAI_RESET}"
        return 1
      fi

      echo -e "${CWR} ${BONSAI_YELLOW}Installed systemd-boot files without touching firmware variables; NVRAM entries will be created separately.${BONSAI_RESET}"
    fi

    # Ensure fallback path exists (important for firmware that wipes NVRAM)
    arch-chroot /mnt mkdir -p /boot/EFI/BOOT
    arch-chroot /mnt cp -f /boot/EFI/systemd/systemd-bootx64.efi /boot/EFI/BOOT/BOOTX64.EFI || true

    mkdir -p /mnt/boot/loader/entries

    cat << 'EOF' > /mnt/boot/loader/loader.conf
default  arch
timeout  5
console-mode max
editor   no
EOF

    local entry_path="/mnt/boot/loader/entries/arch.conf"
    local fallback_entry_path="/mnt/boot/loader/entries/arch-fallback.conf"

    # ---------- FIXED: build kernel options from the actual mounted root ----------
    local kernel_opts
    kernel_opts="$(derive_kernel_opts)"

    # Determine entry title based on distro (keeping Arch Linux name as per user preference)
    local entry_title="Arch Linux"

    cat << EOF > "$entry_path"
title   $entry_title
linux   /vmlinuz-$KERNEL_TYPE
initrd  /initramfs-$KERNEL_TYPE.img
options $kernel_opts
EOF

    cat << EOF > "$fallback_entry_path"
title   $entry_title (Fallback)
linux   /vmlinuz-$KERNEL_TYPE
initrd  /initramfs-$KERNEL_TYPE-fallback.img
options $kernel_opts
EOF

    # Microcode if present - insert before kernel initramfs
    if [ -f /mnt/boot/intel-ucode.img ]; then
      sed -i "/^initrd  \/initramfs-$KERNEL_TYPE\\.img/i initrd  /intel-ucode.img" "$entry_path"
      sed -i "/^initrd  \/initramfs-$KERNEL_TYPE-fallback/i initrd  /intel-ucode.img" "$fallback_entry_path"
    elif [ -f /mnt/boot/amd-ucode.img ]; then
      sed -i "/^initrd  \/initramfs-$KERNEL_TYPE\\.img/i initrd  /amd-ucode.img" "$entry_path"
      sed -i "/^initrd  \/initramfs-$KERNEL_TYPE-fallback/i initrd  /amd-ucode.img" "$fallback_entry_path"
    fi

    if ! resolve_esp_context "/mnt/boot"; then
      return 1
    fi

    if [[ -n "$ESP_PARTUUID" ]]; then
      echo -e "${CNT} ${BONSAI_TEXT}Using ESP ${BONSAI_YELLOW}$ESP_DEV${BONSAI_TEXT} (PARTUUID=${BONSAI_YELLOW}$ESP_PARTUUID${BONSAI_TEXT}).${BONSAI_RESET}"
    else
      echo -e "${CNT} ${BONSAI_TEXT}Using ESP ${BONSAI_YELLOW}$ESP_DEV${BONSAI_TEXT}.${BONSAI_RESET}"
    fi

    local entry_label="BONSAI Linux (systemd-boot)"
    local loader_path='\\EFI\\systemd\\systemd-bootx64.efi'

    if arch-chroot /mnt efibootmgr | grep -E "Linux Boot Manager|systemd-boot|${entry_label}" > /dev/null 2>&1; then
      echo -e "${COK} ${BONSAI_TEXT}Detected existing EFI entry for systemd-boot${BONSAI_RESET}"
    else
      echo -e "${CWR} ${BONSAI_YELLOW}EFI entry not detected. Attempting to register ${entry_label}...${BONSAI_RESET}"
      if ! register_efi_entry "$entry_label" "$loader_path"; then
        echo -e "${CER} ${BONSAI_RED}Failed to ensure EFI entry for systemd-boot.${BONSAI_RESET}"
        return 1
      fi
    fi

    if ! arch-chroot /mnt efibootmgr | grep -E "Linux Boot Manager|systemd-boot|${entry_label}" > /dev/null 2>&1; then
      echo -e "${CWR} ${BONSAI_YELLOW}WARNING: systemd-boot entry is still absent. Verify firmware configuration manually.${BONSAI_RESET}"
    fi

    echo -e "${COK} ${BONSAI_TEXT}systemd-boot installed successfully${BONSAI_RESET}"
    return 0
  }

  # Verify EFI system
  echo -e "${CNT} ${BONSAI_TEXT}Verifying EFI system...${BONSAI_RESET}"
  if [ -d /sys/firmware/efi ]; then
    echo -e "${COK} ${BONSAI_TEXT}EFI system detected${BONSAI_RESET}"
  else
    echo -e "${CER} ${BONSAI_RED}WARNING: EFI system not detected!${BONSAI_RESET}"
    exit 1
  fi

  if ! mountpoint -q /mnt/boot; then
    echo -e "${CER} ${BONSAI_RED}Boot partition not mounted!${BONSAI_RESET}"
    echo -e "${CNT} ${BONSAI_TEXT}Attempting to mount boot partition...${BONSAI_RESET}"
    if ! mount "$PARTITION1" /mnt/boot; then
      echo -e "${CER} ${BONSAI_RED}Failed to mount ${BONSAI_YELLOW}$PARTITION1${BONSAI_RED} to /mnt/boot.${BONSAI_RESET}"
      exit 1
    fi
  fi

  if ! ensure_efivarfs_accessible; then
    exit 1
  fi

  # Install selected bootloader
  if [ "$BOOTLOADER_TYPE" = "systemd-boot" ]; then
    if ! install_systemd_boot; then
      exit 1
    fi
  else
    if ! install_grub; then
      exit 1
    fi
  fi

  echo -e "${CNT} ${BONSAI_TEXT}Verifying EFI boot entries...${BONSAI_RESET}"
  local efiboot_output
  if efiboot_output=$(arch-chroot /mnt efibootmgr -v 2>&1); then
    echo "$efiboot_output"
  else
    echo -e "${CWR} ${BONSAI_YELLOW}efibootmgr could not enumerate entries. Verify UEFI settings manually.${BONSAI_RESET}"
  fi

  if [ "$BOOTLOADER_TYPE" = "systemd-boot" ]; then
    if grep -E "Linux Boot Manager|systemd-boot|BONSAI Linux \\(systemd-boot\\)" <<< "$efiboot_output" > /dev/null 2>&1; then
      echo -e "${COK} ${BONSAI_TEXT}EFI boot entry detected for systemd-boot${BONSAI_RESET}"
    else
      echo -e "${CWR} ${BONSAI_YELLOW}WARNING: EFI boot entry for systemd-boot not visible in firmware output.${BONSAI_RESET}"
    fi
    verify_efi_entry_targets_esp "systemd-boot" "$efiboot_output"
  else
    if grep -E "GRUB|BONSAI Linux \\(GRUB\\)|Arch" <<< "$efiboot_output" > /dev/null 2>&1; then
      echo -e "${COK} ${BONSAI_TEXT}EFI boot entry detected for GRUB${BONSAI_RESET}"
    else
      echo -e "${CWR} ${BONSAI_YELLOW}WARNING: EFI boot entry for GRUB not visible in firmware output.${BONSAI_RESET}"
    fi
    verify_efi_entry_targets_esp "GRUB" "$efiboot_output"
  fi

  echo -e "\n${CNT} ${BONSAI_TEXT}Creating user account...${BONSAI_RESET}"
  if ! arch-chroot /mnt useradd -m -G wheel -- "$userstr"; then
    echo -e "${CER} ${BONSAI_RED}Failed to create user ${BONSAI_YELLOW}$userstr${BONSAI_RED}.${BONSAI_RESET}"
    exit 1
  fi

  show_section "User Password"
  echo -e "${CWR} ${BONSAI_YELLOW}Please set password for user $userstr:${BONSAI_RESET}"
  if ! arch-chroot /mnt passwd -- "$userstr"; then
    echo -e "${CER} ${BONSAI_RED}Failed to set password for ${BONSAI_YELLOW}$userstr${BONSAI_RED}.${BONSAI_RESET}"
    exit 1
  fi

  echo -e "\n${CNT} ${BONSAI_TEXT}Configuring sudo...${BONSAI_RESET}"
  variable="%wheel ALL=(ALL:ALL) ALL"
  arch-chroot /mnt sed -i "/^# $variable/s/#\s*//" /etc/sudoers

  echo -e "${CNT} ${BONSAI_TEXT}Enabling services...${BONSAI_RESET}"
  arch-chroot /mnt systemctl enable NetworkManager
  arch-chroot /mnt systemctl enable ntpd.service

  echo -e "${CNT} ${BONSAI_TEXT}Copying installation files...${BONSAI_RESET}"
  if ! cp -a "$SCRIPT_ROOT" "/mnt/home/$userstr/archinstall"; then
    echo -e "${CER} ${BONSAI_RED}Failed to copy installer files to the new user home.${BONSAI_RESET}"
    exit 1
  fi
  if ! arch-chroot /mnt chown -R "$userstr:$userstr" "/home/$userstr/archinstall"; then
    echo -e "${CER} ${BONSAI_RED}Failed to adjust ownership for /mnt/home/$userstr/archinstall.${BONSAI_RESET}"
    exit 1
  fi

  if [ "$EFIVARFS_BOUND_CHROOT" = true ] && [ -e /mnt/sys/firmware/efi/efivars ]; then
    if mountpoint -q /mnt/sys/firmware/efi/efivars; then
      umount /mnt/sys/firmware/efi/efivars 2> /dev/null || umount -l /mnt/sys/firmware/efi/efivars 2> /dev/null
    fi
    EFIVARFS_BOUND_CHROOT=false
  fi

  if [ "$EFIVARFS_HOST_MOUNTED" = true ] && [ -e /sys/firmware/efi/efivars ]; then
    if mountpoint -q /sys/firmware/efi/efivars; then
      umount /sys/firmware/efi/efivars 2> /dev/null || umount -l /sys/firmware/efi/efivars 2> /dev/null
    fi
    EFIVARFS_HOST_MOUNTED=false
  fi

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
  for SOFTWR in "${uninstall_stage[@]}"; do
    uninstall_software $SOFTWR
  done

  echo -e "\n${CNT} ${BONSAI_TEXT}Installing Pipewire audio system...${BONSAI_RESET}"
  for SOFTWR in "${pipewire_stage[@]}"; do
    install_software $SOFTWR
  done

  echo -e "\n${CNT} ${BONSAI_TEXT}Installing Hyprland components...${BONSAI_RESET}"
  for SOFTWR in "${hypr_base_stage[@]}"; do
    install_software $SOFTWR
  done

  # Nvidia detection and setup
  if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    ISNVIDIA=true
  else
    ISNVIDIA=false
  fi

  if [[ $ISNVIDIA == true ]]; then
    show_section "NVIDIA GPU Configuration"

    echo -e "${CNT} ${BONSAI_TEXT}NVIDIA GPU detected, installing drivers...${BONSAI_RESET}"

    for SOFTWR in "${uninstall_nvidia_stage[@]}"; do
      uninstall_software $SOFTWR
    done

    # Select appropriate NVIDIA package set based on distro
    if [ "$DISTRO_TYPE" = "cachyos" ]; then
      # For CachyOS: install kernel headers first, then DKMS driver
      echo -e "${CNT} ${BONSAI_TEXT}Installing CachyOS kernel headers...${BONSAI_RESET}"
      install_software $KERNEL_HEADERS
      for SOFTWR in "${nvidia_stage_cachyos[@]}"; do
        install_software $SOFTWR
      done
    else
      # For Arch Linux: use standard nvidia package
      for SOFTWR in "${nvidia_stage_arch[@]}"; do
        install_software $SOFTWR
      done
    fi

    if grep -qE '^MODULES=.*nvidia. *nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
      echo -e "${COK} ${BONSAI_TEXT}Nvidia modules already configured${BONSAI_RESET}"
    else
      sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
      echo -e "${COK} ${BONSAI_TEXT}Nvidia modules added to mkinitcpio.conf${BONSAI_RESET}"
    fi

    sudo mkinitcpio -P 2>&1 | tee -a "$INSTLOG"

    NVEA="/etc/modprobe.d/nvidia.conf"
    if [ -f "$NVEA" ]; then
      echo -e "${COK} ${BONSAI_TEXT}Nvidia modeset already configured${BONSAI_RESET}"
    else
      echo -e "${CNT} ${BONSAI_TEXT}Adding Nvidia modeset configuration...${BONSAI_RESET}"
      sudo bash -c 'echo "options nvidia_drm modeset=1 fbdev=1" > /etc/modprobe.d/nvidia.conf'
    fi
  fi

  echo -e "\n${CNT} ${BONSAI_TEXT}Installing development tools and applications...${BONSAI_RESET}"
  echo -e "${BONSAI_MUTED}This will take some time, please be patient...${BONSAI_RESET}\n"

  for SOFTWR in "${tools_stage[@]}"; do
    install_software $SOFTWR
  done

  echo -e "\n${CNT} ${BONSAI_TEXT}Installing uv (Python package manager)...${BONSAI_RESET}"
  curl -LsSf https://astral.sh/uv/install.sh | sh

  echo -e "\n${CNT} ${BONSAI_TEXT}Installing yarn (via corepack)...${BONSAI_RESET}"
  sudo npm install -g corepack

  echo -e "\n${CNT} ${BONSAI_TEXT}Installing bun (JavaScript runtime)...${BONSAI_RESET}"
  curl -fsSL https://bun.sh/install | bash

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

  if [[ ! -d ~/archinstall/dotfiles ]]; then
    echo -e "${CER} ${BONSAI_RED}Dotfiles not found at ~/archinstall/dotfiles${BONSAI_RESET}"
    return 1
  fi

  echo -e "${CNT} ${BONSAI_TEXT}Restoring configuration files...${BONSAI_RESET}\n"

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

  echo -e "${CNT} ${BONSAI_TEXT}Configuring VS Code...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config code

  echo -e "${CNT} ${BONSAI_TEXT}Configuring Bottom system monitor...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config bottom

  echo -e "${CNT} ${BONSAI_TEXT}Configuring Zathura...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config zathura

  echo -e "${CNT} ${BONSAI_TEXT}Configuring Hyfetch...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config hyfetch

  echo -e "${CNT} ${BONSAI_TEXT}Configuring LazyGit...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config lazygit

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

  echo -e "\n${CNT} ${BONSAI_TEXT}Configuring remaining applications...${BONSAI_RESET}"

  rm -rf ~/.config/waybar
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config waybar

  rm -rf ~/.config/rofi
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config rofi

  echo -e "${CNT} ${BONSAI_TEXT}Installing ZSH plugins...${BONSAI_RESET}"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ~/archinstall/catppuccin-zsh-syntax-highlighting
  git clone --depth=1 https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode

  echo -e "${CNT} ${BONSAI_TEXT}Installing FZF-Git...${BONSAI_RESET}"
  git clone https://github.com/junegunn/fzf-git.sh.git ~/archinstall/fzf-git

  echo -e "${CNT} ${BONSAI_TEXT}Configuring TMUX...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/home tmux
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  echo -e "${CNT} ${BONSAI_TEXT}Configuring shell...${BONSAI_RESET}"
  rm -rf ~/.zshrc
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/home zshrc
  rm -rf ~/.p10k.zsh
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/home p10k

  echo -e "${CNT} ${BONSAI_TEXT}Installing themes and icons...${BONSAI_RESET}"
  rm -rf ~/.themes
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/home themes
  rm -rf ~/.icons
  cp -r ~/archinstall/dotfiles/home/icons/.icons ~/
  unzip ~/.icons/WhiteSur.zip -d ~/.icons/

  echo -e "${CNT} ${BONSAI_TEXT}Configuring Kitty terminal...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config/ kitty

  echo -e "${CNT} ${BONSAI_TEXT}Configuring Mutt email client...${BONSAI_RESET}"
  mkdir -p ~/.cache/mutt/{headers,messages}
  mkdir -p ~/.config/mutt/accounts
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config mutt
  chmod +x ~/.config/mutt/scripts/*.sh

  echo -e "${CNT} ${BONSAI_TEXT}Configuring Calcurse calendar...${BONSAIRESET}"
  mkdir -p ~/.local/share/calcurse
  mkdir -p ~/.config/calcurse/{hooks,caldav}
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config calcurse
  chmod +x ~/.config/calcurse/scripts/*.sh 2> /dev/null || true
  systemctl --user enable calcurse-notify.service 2> /dev/null || true

  echo -e "${CNT} ${BONSAI_TEXT}Configuring procs process viewer...${BONSAI_RESET}"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config procs

  if [ ! -d ~/.password-store ]; then
    echo -e "${CNT} ${BONSAI_TEXT}Initializing password store...${BONSAI_RESET}"
    gpg_key=$(gpg --list-secret-keys --keyid-format LONG 2> /dev/null | grep sec | head -1 | awk '{print $2}' | cut -d'/' -f2)
    if [ -n "$gpg_key" ]; then
      pass init "$gpg_key"
    else
      echo -e "${CWR} ${BONSAI_YELLOW}No GPG key found. Run 'gpg --gen-key' to create one${BONSAI_RESET}"
    fi
  fi

  echo -e "${CNT} ${BONSAI_TEXT}Configuring Bat...${BONSAI_RESET}"
  mkdir -p "$(bat --config-dir)/themes"
  wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
  bat cache --build

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

function update_bootloader_sddm() {
  show_bonsai_header
  show_section "Bootloader & SDDM Theme Update"

  if [[ ! -d ~/archinstall/dotfiles ]]; then
    echo -e "${CER} ${BONSAI_RED}Dotfiles not found at ~/archinstall/dotfiles${BONSAI_RESET}"
    return 1
  fi

  echo -e "${CNT} ${BONSAI_TEXT}Installing BONSAI themes...${BONSAI_RESET}\n"

  local DETECTED_BOOTLOADER=$(detect_bootloader)
  local SELECTED_PART=""

  if [ "$DETECTED_BOOTLOADER" = "none" ]; then
    echo -e "${CER} ${BONSAI_RED}No supported bootloader detected!${BONSAI_RESET}"
    echo -e "${CAT} ${BONSAI_YELLOW}Please install GRUB or systemd-boot first.${BONSAI_RESET}"
    return 1
  fi

  echo -e "${CNT} ${BONSAI_TEXT}Detected bootloader: ${BONSAI_GREEN}$DETECTED_BOOTLOADER${BONSAI_RESET}\n"

  echo -e "${CNT} ${BONSAI_TEXT}Configuring SDDM with BONSAI theme...${BONSAI_RESET}"
  sudo cp -r ~/archinstall/dotfiles/etc/sddm.conf /etc/
  sudo cp -r ~/archinstall/dotfiles/usr/share/sddm/themes/bonsai/ /usr/share/sddm/themes/

  # Verify SDDM theme installation
  if [ -f /usr/share/sddm/themes/bonsai/Main.qml ]; then
    echo -e "${COK} ${BONSAI_TEXT}SDDM BONSAI theme installed successfully${BONSAI_RESET}"
  else
    echo -e "${CER} ${BONSAI_RED}SDDM theme installation failed!${BONSAI_RESET}"
  fi

  if [[ $DETECTED_BOOTLOADER == "grub" ]]; then
    echo -e "${CNT} ${BONSAI_TEXT}Configuring GRUB with BONSAI theme...${BONSAI_RESET}"
    sudo cp -r ~/archinstall/dotfiles/etc/default/grub /etc/default/
    sudo cp -r ~/archinstall/dotfiles/usr/share/grub/themes/* /boot/grub/themes/
  fi

  if [[ $DETECTED_BOOTLOADER == "grub" ]]; then
    if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
      ISNVIDIA=true
    else
      ISNVIDIA=false
    fi

    if [[ $ISNVIDIA == true ]]; then
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
  elif [[ $DETECTED_BOOTLOADER == "systemd-boot" ]]; then
    if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
      echo -e "${CNT} ${BONSAI_TEXT}Configuring systemd-boot for NVIDIA...${BONSAI_RESET}"
      for entry in /boot/loader/entries/*.conf; do
        if [ -f "$entry" ]; then
          if ! grep -q "nvidia-drm.modeset=1" "$entry"; then
            sudo sed -i "/^options/ s/$/ nvidia-drm.modeset=1 nvidia_drm.fbdev=1/" "$entry"
            echo -e "${COK} ${BONSAI_TEXT}NVIDIA parameters added to $(basename $entry)${BONSAI_RESET}"
          fi
        fi
      done
    fi
  fi

  if [[ $DETECTED_BOOTLOADER == "grub" ]]; then
    show_section "GRUB Encryption Configuration"
  else
    show_section "systemd-boot Configuration"
  fi

  echo -e "${CNT} ${BONSAI_TEXT}Is your system encrypted?${BONSAI_RESET}\n"
  echo -e "  ${BONSAI_GREEN}[1]${BONSAI_RESET} ${BONSAI_TEXT}Yes (encrypted)${BONSAI_RESET}"
  echo -e "  ${BONSAI_GREEN}[2]${BONSAI_RESET} ${BONSAI_TEXT}No (standard)${BONSAI_RESET}"

  echo ""
  read -p "$(echo -e ${BONSAI_YELLOW}Select option [1-2]: ${BONSAI_RESET})" enc_status

  if [[ $enc_status == "1" ]]; then
    echo -e "\n${CNT} ${BONSAI_TEXT}Detecting encrypted partition...${BONSAI_RESET}"

    echo -e "${BONSAI_MUTED}"
    sudo lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT
    echo -e "${BONSAI_RESET}"

    luks_parts=$(lsblk -rno NAME,FSTYPE | grep crypto_LUKS | awk '{print $1}')

    if [ -n "$luks_parts" ]; then
      echo -e "${COK} ${BONSAI_TEXT}Found encrypted partition: ${BONSAI_GREEN}/dev/$luks_parts${BONSAI_RESET}"
      SELECTED_PART="/dev/$luks_parts"
    else
      echo -e "${CWR} ${BONSAI_YELLOW}Could not auto-detect encrypted partition${BONSAI_RESET}"

      disks=($(lsblk -dno NAME,TYPE | grep disk | awk '{print $1}'))

      echo -e "\n${CNT} ${BONSAI_TEXT}Select disk containing encrypted partition:${BONSAI_RESET}\n"
      for i in "${!disks[@]}"; do
        local disk="${disks[$i]}"
        local size=$(lsblk -dno SIZE /dev/$disk 2> /dev/null)
        local filesystems=$(lsblk -no FSTYPE /dev/$disk 2> /dev/null | grep -v "^$" | sort -u | tr '\n' ',' | sed 's/,$//' | sed 's/,/, /g')
        [[ -z "$filesystems" ]] && filesystems="none"
        echo -e "  ${BONSAI_GREEN}[$((i + 1))]${BONSAI_RESET} ${BONSAI_TEXT}/dev/$disk${BONSAI_RESET} - ${BONSAI_MUTED}$size${BONSAI_RESET} ${BONSAI_PURPLE}[fs: $filesystems]${BONSAI_RESET}"
      done

      echo ""
      read -p "$(echo -e ${BONSAI_YELLOW}Select disk [1-${#disks[@]}]: ${BONSAI_RESET})" disk_choice

      if [[ $disk_choice =~ ^[0-9]+$ ]] && [ "$disk_choice" -ge 1 ] && [ "$disk_choice" -le "${#disks[@]}" ]; then
        selected_disk="${disks[$((disk_choice - 1))]}"
        if [[ $selected_disk == nvme* || $selected_disk == mmcblk* ]]; then
          SELECTED_PART="/dev/${selected_disk}p2"
        else
          SELECTED_PART="/dev/${selected_disk}2"
        fi
      fi
    fi

    if [ -n "$SELECTED_PART" ]; then
      deviceUUID=$(sudo blkid -s UUID -o value $SELECTED_PART)
      if [[ $DETECTED_BOOTLOADER == "grub" ]]; then
        variable="GRUB_CMDLINE_LINUX"
        # Preserve existing, append crypt + mapper root
        if grep -q '^GRUB_CMDLINE_LINUX=' /etc/default/grub; then
          sudo sed -i "s|^GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${deviceUUID}:root:allow-discards\"|" /etc/default/grub
        else
          echo "GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${deviceUUID}:root:allow-discards\"" | sudo tee -a /etc/default/grub > /dev/null
        fi
      fi
    fi
  fi

  if [[ $DETECTED_BOOTLOADER == "grub" ]]; then
    echo -e "\n${CNT} ${BONSAI_TEXT}Regenerating GRUB configuration...${BONSAI_RESET}"
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    echo -e "\n${COK} ${BONSAI_GREEN}GRUB and SDDM themes updated successfully!${BONSAI_RESET}"
  else
    echo -e "\n${CNT} ${BONSAI_TEXT}Updating systemd-boot entries...${BONSAI_RESET}"
    if [[ $enc_status == "1" ]] && [ -n "$SELECTED_PART" ]; then
      deviceUUID=$(sudo blkid -s UUID -o value $SELECTED_PART)
      for entry in /boot/loader/entries/*.conf; do
        if [ -f "$entry" ]; then
          if ! grep -q "cryptdevice=" "$entry"; then
            sudo sed -i "/^options/ s/$/ cryptdevice=UUID=${deviceUUID}:root root=\/dev\/mapper\/root/" "$entry"
            echo -e "${COK} ${BONSAI_TEXT}Updated $(basename $entry) with encryption parameters${BONSAI_RESET}"
          fi
        fi
      done
    fi
    echo -e "${CNT} ${BONSAI_TEXT}Note: systemd-boot uses text-based menu (no graphical themes)${BONSAI_RESET}"
    echo -e "\n${COK} ${BONSAI_GREEN}systemd-boot and SDDM configuration updated successfully!${BONSAI_RESET}"
  fi
}

# Convert existing Arch Linux to CachyOS
function convert_to_cachyos() {
  show_bonsai_header
  show_section "Convert Arch Linux to CachyOS"

  echo -e "${CWR} ${BONSAI_YELLOW}This will convert your Arch Linux to CachyOS:${BONSAI_RESET}\n"
  echo -e "  ${BONSAI_TEXT}• Add CachyOS repositories (x86-64-v3 optimized)${BONSAI_RESET}"
  echo -e "  ${BONSAI_TEXT}• Install a CachyOS optimized kernel${BONSAI_RESET}"
  echo -e "  ${BONSAI_TEXT}• Upgrade key packages to CachyOS builds${BONSAI_RESET}"
  echo -e "  ${BONSAI_TEXT}• Update NVIDIA drivers to DKMS (if applicable)${BONSAI_RESET}"
  echo -e "  ${BONSAI_TEXT}• Update bootloader configuration${BONSAI_RESET}"

  echo -e "\n${CAT} ${BONSAI_YELLOW}Recommended: Create a Timeshift snapshot first!${BONSAI_RESET}\n"

  read -p "$(echo -e ${BONSAI_YELLOW}Continue with conversion? [y/N]: ${BONSAI_RESET})" confirm
  if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo -e "${CNT} ${BONSAI_TEXT}Conversion cancelled${BONSAI_RESET}"
    return
  fi

  # Step 1: Add CachyOS repositories
  echo -e "\n${CNT} ${BONSAI_TEXT}Step 1/6: Adding CachyOS repositories...${BONSAI_RESET}"
  configure_cachyos_repos_running

  # Step 2: Select kernel variant
  echo -e "\n${CNT} ${BONSAI_TEXT}Step 2/6: Selecting CachyOS kernel...${BONSAI_RESET}"
  select_cachyos_kernel

  # Step 3: Install new kernel + headers
  echo -e "\n${CNT} ${BONSAI_TEXT}Step 3/6: Installing ${KERNEL_TYPE} kernel...${BONSAI_RESET}"
  sudo pacman -S --noconfirm $KERNEL_TYPE $KERNEL_HEADERS

  # Step 4: Install CachyOS optimized packages
  echo -e "\n${CNT} ${BONSAI_TEXT}Step 4/6: Upgrading to CachyOS-optimized packages...${BONSAI_RESET}"
  for pkg in "${cachyos_optimized_packages[@]}"; do
    echo -e "${CNT} ${BONSAI_MUTED}Installing $pkg...${BONSAI_RESET}"
    sudo pacman -S --noconfirm --needed $pkg 2>/dev/null || true
  done

  # Step 5: Handle NVIDIA (detect GPU hardware, install/convert to DKMS)
  if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    echo -e "\n${CNT} ${BONSAI_TEXT}Step 5/6: NVIDIA GPU detected, configuring DKMS driver...${BONSAI_RESET}"

    # Remove ALL existing nvidia packages to avoid conflicts
    # This handles nvidia, nvidia-open, nvidia-dkms, and their utils
    local nvidia_pkgs_to_remove=()
    for pkg in nvidia nvidia-open nvidia-open-dkms nvidia-lts nvidia-dkms \
               nvidia-utils nvidia-settings nvidia-535xx-dkms nvidia-535xx-utils \
               nvidia-550xx-dkms nvidia-550xx-utils; do
      if pacman -Q "$pkg" &>/dev/null; then
        nvidia_pkgs_to_remove+=("$pkg")
      fi
    done

    if [[ ${#nvidia_pkgs_to_remove[@]} -gt 0 ]]; then
      echo -e "${CWR} ${BONSAI_YELLOW}Removing existing NVIDIA packages: ${nvidia_pkgs_to_remove[*]}${BONSAI_RESET}"
      sudo pacman -Rdd --noconfirm "${nvidia_pkgs_to_remove[@]}" 2>/dev/null || true
    fi

    # Install CachyOS NVIDIA DKMS driver
    # Use nvidia-open-dkms from extra repo (latest, open-source kernel modules)
    echo -e "${CNT} ${BONSAI_TEXT}Installing nvidia-open-dkms and utilities...${BONSAI_RESET}"
    sudo pacman -S --noconfirm nvidia-open-dkms nvidia-utils nvidia-settings

    # Ensure nvidia modules in initramfs
    if ! grep -qE 'nvidia.*nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
      sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
      echo -e "${CNT} ${BONSAI_TEXT}Rebuilding initramfs with NVIDIA modules...${BONSAI_RESET}"
      sudo mkinitcpio -P 2>&1 | tee -a "$INSTLOG"
    fi
  else
    echo -e "\n${CNT} ${BONSAI_TEXT}Step 5/6: No NVIDIA GPU detected, skipping...${BONSAI_RESET}"
  fi

  # Step 6: Update bootloader
  echo -e "\n${CNT} ${BONSAI_TEXT}Step 6/6: Updating bootloader configuration...${BONSAI_RESET}"
  local DETECTED_BOOTLOADER=$(detect_bootloader)

  if [[ $DETECTED_BOOTLOADER == "grub" ]]; then
    echo -e "${CNT} ${BONSAI_TEXT}Regenerating GRUB configuration...${BONSAI_RESET}"
    sudo grub-mkconfig -o /boot/grub/grub.cfg
  elif [[ $DETECTED_BOOTLOADER == "systemd-boot" ]]; then
    echo -e "${CNT} ${BONSAI_TEXT}Creating systemd-boot entry for ${KERNEL_TYPE}...${BONSAI_RESET}"

    # Detect current root partition
    local root_part=$(findmnt -n -o SOURCE /)
    local root_uuid=$(sudo blkid -s UUID -o value $root_part)

    # Detect if system is encrypted
    local crypt_opts=""
    if [ -d /dev/mapper ] && ls /dev/mapper/root &>/dev/null; then
      local luks_part=$(lsblk -rno NAME,FSTYPE | grep crypto_LUKS | head -1 | awk '{print $1}')
      if [ -n "$luks_part" ]; then
        local luks_uuid=$(sudo blkid -s UUID -o value /dev/$luks_part)
        crypt_opts="cryptdevice=UUID=${luks_uuid}:root root=/dev/mapper/root"
      fi
    fi

    # Build kernel options
    local kernel_opts="rw"
    if [ -n "$crypt_opts" ]; then
      kernel_opts="$crypt_opts $kernel_opts"
    else
      kernel_opts="root=UUID=${root_uuid} $kernel_opts"
    fi

    # Add NVIDIA options if needed
    if pacman -Q nvidia-dkms &>/dev/null || pacman -Q nvidia &>/dev/null; then
      kernel_opts="$kernel_opts nvidia-drm.modeset=1 nvidia_drm.fbdev=1"
    fi

    # Create new boot entry
    local entry_name="${KERNEL_TYPE}.conf"
    local entry_path="/boot/loader/entries/${entry_name}"
    local entry_title="Arch Linux (CachyOS ${KERNEL_TYPE})"

    # Detect microcode
    local microcode_line=""
    if [ -f /boot/intel-ucode.img ]; then
      microcode_line="initrd  /intel-ucode.img"
    elif [ -f /boot/amd-ucode.img ]; then
      microcode_line="initrd  /amd-ucode.img"
    fi

    sudo tee "$entry_path" > /dev/null << EOF
title   $entry_title
linux   /vmlinuz-$KERNEL_TYPE
${microcode_line}
initrd  /initramfs-$KERNEL_TYPE.img
options $kernel_opts
EOF

    echo -e "${COK} ${BONSAI_TEXT}Created boot entry: ${entry_name}${BONSAI_RESET}"

    # Set as default
    sudo sed -i "s/^default .*/default ${entry_name}/" /boot/loader/loader.conf
    echo -e "${COK} ${BONSAI_TEXT}Set ${entry_name} as default boot entry${BONSAI_RESET}"
  else
    echo -e "${CWR} ${BONSAI_YELLOW}No supported bootloader detected. Manual configuration required.${BONSAI_RESET}"
  fi

  echo -e "\n${COK} ${BONSAI_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BONSAI_RESET}"
  echo -e "${COK} ${BONSAI_GREEN}CachyOS conversion complete!${BONSAI_RESET}"
  echo -e "${COK} ${BONSAI_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${BONSAI_RESET}"
  echo -e "\n${CNT} ${BONSAI_TEXT}Changes made:${BONSAI_RESET}"
  echo -e "  ${BONSAI_TEXT}• CachyOS repositories added${BONSAI_RESET}"
  echo -e "  ${BONSAI_TEXT}• Kernel: ${BONSAI_GREEN}${KERNEL_TYPE}${BONSAI_RESET}"
  echo -e "  ${BONSAI_TEXT}• Optimized packages installed${BONSAI_RESET}"
  if pacman -Q nvidia-dkms &>/dev/null; then
    echo -e "  ${BONSAI_TEXT}• NVIDIA: ${BONSAI_GREEN}nvidia-dkms${BONSAI_RESET}"
  fi
  echo -e "  ${BONSAI_TEXT}• Bootloader: ${BONSAI_GREEN}${DETECTED_BOOTLOADER}${BONSAI_RESET}"

  echo -e "\n${CAT} ${BONSAI_YELLOW}Reboot required to use the new CachyOS kernel!${BONSAI_RESET}\n"

  read -p "$(echo -e ${BONSAI_YELLOW}Reboot now? [y/N]: ${BONSAI_RESET})" reboot_choice
  if [[ $reboot_choice =~ ^[Yy]$ ]]; then
    echo -e "${CNT} ${BONSAI_TEXT}Rebooting in 3 seconds...${BONSAI_RESET}"
    sleep 3
    sudo reboot
  fi
}

# Main menu with BONSAI styling
function main_menu() {
  while true; do
    show_bonsai_header

    echo -e "${BONSAI_TEXT}Welcome to the BONSAI Arch Linux Installer${BONSAI_RESET}"
    echo -e "${BONSAI_MUTED}Enhanced installation experience with zen aesthetics${BONSAI_RESET}\n"

    echo -e "${CNT} ${BONSAI_TEXT}Select an action:${BONSAI_RESET}\n"
    echo -e "  ${BONSAI_GREEN}[1]${BONSAI_RESET} ${BONSAI_TEXT}Install Arch Linux${BONSAI_RESET} ${BONSAI_MUTED}(or CachyOS base system)${BONSAI_RESET}"
    echo -e "  ${BONSAI_GREEN}[2]${BONSAI_RESET} ${BONSAI_TEXT}Install Hyprland${BONSAI_RESET} ${BONSAI_MUTED}(Desktop environment)${BONSAI_RESET}"
    echo -e "  ${BONSAI_GREEN}[3]${BONSAI_RESET} ${BONSAI_TEXT}Restore Dotfiles${BONSAI_RESET} ${BONSAI_MUTED}(Configuration files)${BONSAI_RESET}"
    echo -e "  ${BONSAI_GREEN}[4]${BONSAI_RESET} ${BONSAI_TEXT}Update Bootloader/SDDM${BONSAI_RESET} ${BONSAI_MUTED}(Themes)${BONSAI_RESET}"
    echo -e "  ${BONSAI_GREEN}[5]${BONSAI_RESET} ${BONSAI_TEXT}Convert to CachyOS${BONSAI_RESET} ${BONSAI_MUTED}(Existing Arch)${BONSAI_RESET}"
    echo -e "  ${BONSAI_GREEN}[6]${BONSAI_RESET} ${BONSAI_TEXT}Exit${BONSAI_RESET}"

    echo ""
    read -p "$(echo -e ${BONSAI_YELLOW}Select option [1-6]: ${BONSAI_RESET})" menu_choice

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
        update_bootloader_sddm
        ;;
      5)
        convert_to_cachyos
        ;;
      6)
        echo -e "\n${COK} ${BONSAI_GREEN}Thank you for using BONSAI installer!${BONSAI_RESET}"
        echo -e "${BONSAI_MUTED}May your system grow with purpose 🌱${BONSAI_RESET}\n"
        exit 0
        ;;
      *)
        echo -e "${CER} ${BONSAI_RED}Invalid selection${BONSAI_RESET}"
        sleep 2
        ;;
    esac
  done
}

# Start the installer
main_menu
