#!/bin/bash
#
#

## Variables
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
  mutt-wizard         # CLI email client
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

# set some colors
CNT="[\e[1;36mNOTE\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"
INSTLOG="install.log"

function pacman_init() {
  clear
  echo -ne "
    ---------------------------------------------------------------------
     █████╗ ██████╗  ██████╗██╗  ██╗    ██████╗  █████╗ ███████╗███████╗
    ██╔══██╗██╔══██╗██╔════╝██║  ██║    ██╔══██╗██╔══██╗██╔════╝██╔════╝
    ███████║██████╔╝██║     ███████║    ██████╔╝███████║███████╗█████╗  
    ██╔══██║██╔══██╗██║     ██╔══██║    ██╔══██╗██╔══██║╚════██║██╔══╝  
    ██║  ██║██║  ██║╚██████╗██║  ██║    ██████╔╝██║  ██║███████║███████╗
    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝
                                                                        
    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗                   
    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║                   
    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║                   
    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║                   
    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗              
    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝                                                                   
    ---------------------------------------------------------------------
    "
  echo ""
  echo "------------------------------------------------------------------------------------------------------------------"
  echo "                                               Pacman Init                                                        "
  echo "------------------------------------------------------------------------------------------------------------------"
  pacman-key --init
  pacman-key --populate archlinux
  variable="Color"
  sed -i "/^#$variable/ c$variable" /etc/pacman.conf
  variable="ParallelDownloads = 5"
  sed -i "/^#$variable/ c$variable" /etc/pacman.conf
  sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
}

function btrfs_format() {
  clear
  echo "------------------------------------------------------------------------------------------------------------------"
  echo "                                               Disk Partitions                                                    "
  echo "------------------------------------------------------------------------------------------------------------------"
  fdisk -l
  echo " "
  read -p 'Enter disk name for installation (e.g. sda or nvme0n1): ' disk

  # Unmount any mounted partitions from this disk and the mount point
  umount /dev/${disk}?* 2> /dev/null
  umount -l /mnt 2> /dev/null

  # Zap the disk and create two partitions:
  #  - Partition 1: 1G for boot (EF00)
  #  - Partition 2: The rest (8300) for encryption and data
  sgdisk --zap-all /dev/$disk
  sgdisk -n 1:0:+1G -n 2:0:0 -t 1:ef00 -t 2:8300 /dev/$disk -p

  # Depending on the disk type, set the partition names.
  if [[ "$disk" == nvme* ]]; then
    # NVMe devices use a 'p' before the partition number
    part1="/dev/${disk}p1"
    part2="/dev/${disk}p2"
  else
    # Regular sd? disks
    part1="/dev/${disk}1"
    part2="/dev/${disk}2"
  fi

  # Format the boot partition as FAT32.
  mkfs.fat -F32 "$part1"

  echo "-----------------------------------------ENCRYPTION------------------------------------------------"
  # Set up LUKS encryption on the second partition.
  cryptsetup -c aes-xts-plain64 --key-size=512 --hash=sha512 --iter-time=3000 \
    --pbkdf=pbkdf2 --use-random luksFormat --type=luks1 "$part2"
  cryptsetup luksOpen "$part2" root

  # Format the decrypted container with BTRFS.
  mkfs.btrfs -f /dev/mapper/root

  # Mount the filesystem and create BTRFS subvolumes.
  mount /dev/mapper/root /mnt
  btrfs subvolume create /mnt/@
  btrfs subvolume create /mnt/@home
  umount /mnt

  # Mount the subvolumes with your desired options.
  mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ /dev/mapper/root /mnt
  mkdir -p /mnt/{boot,home}
  mount -o noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home /dev/mapper/root /mnt/home

  # Mount the boot partition.
  mount "$part1" /mnt/boot

  echo "------------------------------------------------------------------------------------------------------------------"
  echo "                                                Pacstrap Arch                                                     "
  echo "------------------------------------------------------------------------------------------------------------------"
  echo "Select CPU:"
  echo "  1)Intel"
  echo "  2)AMD"
  echo "  3)VMs"

  read -p 'Selection: ' n
  case $n in
    1) pacstrap /mnt base linux linux-firmware nano intel-ucode btrfs-progs ;;
    2) pacstrap /mnt base linux linux-firmware nano amd-ucode btrfs-progs ;;
    3) pacstrap /mnt base linux linux-firmware nano btrfs-progs ;;
    *) echo "invalid option" ;;
  esac
  genfstab -U /mnt >> /mnt/etc/fstab
}

function base_config() {
  clear
  echo -ne "
    ---------------------------------------------------------------------
     █████╗ ██████╗  ██████╗██╗  ██╗    ██████╗  █████╗ ███████╗███████╗
    ██╔══██╗██╔══██╗██╔════╝██║  ██║    ██╔══██╗██╔══██╗██╔════╝██╔════╝
    ███████║██████╔╝██║     ███████║    ██████╔╝███████║███████╗█████╗  
    ██╔══██║██╔══██╗██║     ██╔══██║    ██╔══██╗██╔══██║╚════██║██╔══╝  
    ██║  ██║██║  ██║╚██████╗██║  ██║    ██████╔╝██║  ██║███████║███████╗
    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝
                                                                        
    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗                   
    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║                   
    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║                   
    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║                   
    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗              
    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝              
                                                                    
    ---------------------------------------------------------------------
    "
  echo ""
  read -p 'Enter username: ' userstr
  read -p "Enter hostname: " hoststr
  arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
  arch-chroot /mnt hwclock --systohc
  variable="en_US.UTF-8 UTF-8"
  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/locale.gen
  arch-chroot /mnt locale-gen
  arch-chroot /mnt bash -c "echo \"LANG=en_US.UTF-8\" >> /etc/locale.conf"
  arch-chroot /mnt bash -c "echo \"KEYMAP=de-latin1-nodeadkeys\"  >> /etc/vconsole.conf"
  cmdstr="echo \"$hoststr\" >> /etc/hostname"
  arch-chroot /mnt bash -c "$cmdstr"
  arch-chroot /mnt bash -c "echo \"127.0.0.1	localhost\" >> /etc/hosts"
  arch-chroot /mnt bash -c "echo \"::1		localhost\" >> /etc/hosts"
  cmdstr="echo \"127.0.1.1	$hoststr.localdomain	$hoststr\" >> /etc/hosts"
  arch-chroot /mnt bash -c "$cmdstr"
  echo "------------------------------------------------------------------------------------------------------------------"
  echo "                                               Root Password                                                      "
  echo "------------------------------------------------------------------------------------------------------------------"
  arch-chroot /mnt passwd
  variable="Color"
  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/pacman.conf
  variable="ParallelDownloads = 5"
  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/pacman.conf
  #  variable="\[multilib\]"
  #  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/pacman.conf
  #  variable="Include = \/etc\/pacman.d\/mirrorlist"
  #  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/pacman.conf
  arch-chroot /mnt sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
  arch-chroot /mnt pacman-key --init
  arch-chroot /mnt pacman-key --populate archlinux
  arch-chroot /mnt pacman -Syy
  arch-chroot /mnt pacman --noconfirm -S grub grub-btrfs efibootmgr base-devel linux-headers networkmanager network-manager-applet wpa_supplicant dialog os-prober mtools dosfstools reflector git ntfs-3g xdg-utils xdg-user-dirs neovim vim vi wget iwd ntp archlinux-keyring bash-completion
  arch-chroot /mnt pacman --noconfirm -S broadcom-wl-dkms
  variable="MODULES=()"
  variable_changed="MODULES=(btrfs)"
  arch-chroot /mnt sed -i "/^$variable/ c$variable_changed" /etc/mkinitcpio.conf
  variable="HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)"
  variable_changed="HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)"
  arch-chroot /mnt sed -i "/^$variable/ c$variable_changed" /etc/mkinitcpio.conf
  arch-chroot /mnt mkinitcpio -p linux
  arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id = Arch
  variable="GRUB_DISABLE_OS_PROBER=false"
  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/default/grub
  variable="GRUB_ENABLE_CRYPTODISK=y"
  arch-chroot /mnt sed -i "/^#$variable/ c$variable" /etc/default/grub
  fdisk -l
  echo " "
  read -p 'Enter disk name for installation (e.g. sda2): ' disk
  deviceUUID=$(blkid -s UUID -o value /dev/${disk})
  variable="GRUB_CMDLINE_LINUX="""
  variable_changed="GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${deviceUUID}:MainPart:allow-discards\""
  arch-chroot /mnt sed -i "/^$variable/ c$variable_changed" /etc/default/grub
  arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
  arch-chroot /mnt useradd -mG wheel $userstr
  echo "------------------------------------------------------------------------------------------------------------------"
  echo "                                               User Password                                                      "
  echo "------------------------------------------------------------------------------------------------------------------"
  arch-chroot /mnt passwd $userstr
  variable="%wheel ALL=(ALL:ALL) ALL"
  arch-chroot /mnt sed -i "/^# $variable/s/#\s*//" /etc/sudoers
  arch-chroot /mnt systemctl enable NetworkManager
  arch-chroot /mnt systemctl enable ntpd.service
  # arch-chroot /mnt ntpd --gq
  cp -r ~/archinstall /mnt/home/$userstr
  chmod 777 /mnt/home/$userstr/archinstall
  umount -l /mnt
  echo "------------------------------------------------------------------------------------------------------------------"
  echo "                                                SCRIPT FINISHED                                                   "
  echo "------------------------------------------------------------------------------------------------------------------"
  echo "Select Action:"
  echo "  1)Shutdown"
  echo "  2)Reboot"
  read -p 'Selection: ' n
  case $n in
    1) shutdown now ;;
    2) reboot ;;
    *) echo "invalid option" ;;
  esac
}

function i3_install() {
  clear
  echo -ne "										   
-------------------------------------------------------------------------------------------
██╗  ██╗██╗   ██╗██████╗ ██████╗     ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     
██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     
███████║ ╚████╔╝ ██████╔╝██████╔╝    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     
██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     
██║  ██║   ██║   ██║     ██║  ██║    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝										   
-------------------------------------------------------------------------------------------
 "
  echo ""
  if ! command -v yay &> /dev/null; then
    echo "yay could not be found"
    git clone https://aur.archlinux.org/yay.git
    pushd yay
    makepkg -srci --noconfirm
    popd
    rm -rf yay
  fi

  yay --noconfirm -Syu

  for SOFTWR in ${uninstall_stage[@]}; do
    uninstall_software $SOFTWR
  done

  echo -e "$CNT - Piperwire Stage Install"
  for SOFTWR in ${piperwire_stage[@]}; do
    install_software $SOFTWR
  done

  echo -e "$CNT - Hyprland Stage Install"
  for SOFTWR in ${hypr_base_stage[@]}; do
    install_software $SOFTWR
  done

  # find the Nvidia GPU
  if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    ISNVIDIA=true
  else
    ISNVIDIA=false
  fi
  # Setup Nvidia if it was found
  if [[ "$ISNVIDIA" == true ]]; then
    echo -e "$CNT - Nvidia GPU support setup stage, this may take a while..."
    for SOFTWR in ${uninstall_nvidia_stage[@]}; do
      uninstall_software $SOFTWR
    done

    for SOFTWR in ${nvidia_stage[@]}; do
      install_software $SOFTWR
    done

    # Check if the Nvidia modules are already added in mkinitcpio.conf and add if not
    if grep -qE '^MODULES=.*nvidia. *nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
      echo "Nvidia modules already included in /etc/mkinitcpio.conf" 2>&1 | tee -a "$INSTLOG"
    else
      sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf 2>&1 | tee -a "$INSTLOG"
      echo "Nvidia modules added in /etc/mkinitcpio.conf"
    fi

    sudo mkinitcpio -P 2>&1 | tee -a "$INSTLOG"
    printf "\n\n\n"

    # Additional Nvidia steps
    NVEA="/etc/modprobe.d/nvidia.conf"
    if [ -f "$NVEA" ]; then
      printf "$COK Seems like nvidia-drm modeset=1 is already added in your system..moving on.\n"
      printf "\n"
    else
      printf "\n"
      printf "$CNT Adding options to $NVEA..."
      sudo echo -e "options nvidia_drm modeset=1 fbdev=1" | sudo tee -a /etc/modprobe.d/nvidia.conf 2>&1 | tee -a "$INSTLOG"
      printf "\n"
    fi
  fi

  echo -e "$CNT - Tools Stage Install"
  for SOFTWR in ${tools_stage[@]}; do
    install_software $SOFTWR
  done
  sudo systemctl enable sddm
  sudo systemctl enable bluetooth.service

  # OH MY ZSH / Powerlever10k
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  # install pyenv
  curl https://pyenv.run | bash
  git clone https://github.com/pyenv/pyenv-update.git $(pyenv root)/plugins/pyenv-update
}

show_progress() {
  while ps | grep $1 &> /dev/null; do
    echo -n "."
    sleep 0.5
  done
  echo -en "Done!\n"
  sleep 0.2
}

function install_software() {
  # no package found so installing
  echo -en "$CNT - Now installing $1 ."
  yay -S --noconfirm $1 &>> $INSTLOG &
  show_progress $!
  # test to make sure package installed
  echo -e "\e[1A\e[K$COK - $1 was installed."
}

function uninstall_software() {
  local pkg="$1"
  if yay -Qi "$pkg" &>> /dev/null; then
    # no package found so installing
    echo -en "$CNT - Now uninstalling $pkg ."
    yay -R --noconfirm $pkg &>> $INSTLOG &
    show_progress $!
  else
    echo -en "$CNT $pkg is not installed, skipping uninstallation.\n"
  fi
}

function restore_dotfiles() {
  echo -e "$CNT ### Secrets ###"
  if ls -la ~/ | grep -iqE git-crypt-key; then
    echo -e "$CNT Using git-crypt-key"
    # Uncrypt
    pushd ~/archinstall/
    git-crypt unlock ../git-crypt-key
    popd

    # Secrets
    echo -e "$CNT ### Git Config ###"
    rm -rf ~/.gitconfig
    stow -v 1 -t ~/ -d ~/archinstall/secrets/dotfiles/home gitconfig
  else
    echo -e "$CNT No git-crypt-key. Skipping secrets"
  fi

  echo -e "$CNT ### VS Code ###"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config code

  echo -e "$CNT ### BTOP ###"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config btop

  echo -e "$CNT ### Zathura ###"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config zathura

  echo -e "$CNT ### Hyfetch ###"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config hyfetch

  echo -e "$CNT ### LazyGit ###"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config lazygit

  echo -e "$CNT ### Hyprland ###"
  rm -rf ~/.config/hypr
  echo "Choose PC"
  echo " 1) Desktop"
  echo " 2) Laptop"
  read -p "Selection: " n
  case "$n" in
    1)
      stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config/hypr desktop
      chmod u+x ~/archinstall/dotfiles/config/hypr/desktop/.config/hypr/wallpaper.sh
      ;;
    2)
      stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config/hypr laptop
      chmod u+x ~/archinstall/dotfiles/config/hypr/laptop/.config/hypr/wallpaper.sh
      ;;
    *)
      echo default
      ;;
  esac

  echo -e "$CNT ### Waybar ###"
  rm -rf ~/.config/waybar
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config waybar

  echo -e "$CNT ### Rofi ###"
  rm -rf ~/.config/rofi
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config rofi

  echo -e "$CNT ### OH-MY-ZSH ###"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  pushd ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  git pull
  popd
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  pushd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git pull
  popd
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  pushd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git pull
  popd
  git clone https://github.com/catppuccin/zsh-syntax-highlighting.git ~/archinstall/catppuccin-zsh-syntax-highlighting
  pushd ~/archinstall/catppuccin-zsh-syntax-highlighting
  git pull
  popd
  git clone --depth=1 https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode
  pushd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode
  git pull
  popd

  echo -e "$CNT ### FZF-Git ###"
  git clone https://github.com/junegunn/fzf-git.sh.git ~/archinstall/fzf-git
  pushd ~/archinstall/fzf-git
  git pull
  popd

  echo -e "$CNT ### TMUX ###"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/home tmux
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  pushd ~/.tmux/plugins/tpm
  git pull
  popd

  echo -e "$CNT ### ZSH ###"
  rm -rf ~/.zshrc
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/home zshrc
  echo -e "$CNT ### P10K ###"
  rm -rf ~/.p10k.zsh
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/home p10k
  echo -e "$CNT ### GTK Themes ###"
  rm -rf ~/.themes
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/home themes
  echo -e "$CNT ### Icons ###"
  rm -rf ~/.icons
  cp -r ~/archinstall/dotfiles/home/icons/.icons ~/
  unzip ~/.icons/WhiteSur.zip -d ~/.icons/
  echo -e "$CNT ### Kitty ###"
  stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config/ kitty

  echo -e "$CNT ### Bat ###"
  mkdir -p "$(bat --config-dir)/themes"
  wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
  bat cache --build

  echo -e "$CNT ### Neovim - BONSAIVIM ###"
  # Clone BONSAIVIM if it doesn't exist
  if [ ! -d "$HOME/BONSAIVIM" ]; then
    echo -e "$CNT - Cloning BONSAIVIM repository..."
    git clone https://github.com/Zwelckovich/BONSAIVIM.git ~/BONSAIVIM
  else
    echo -e "$CNT - BONSAIVIM already exists, pulling latest changes..."
    pushd ~/BONSAIVIM
    git pull
    popd
  fi

  # Execute the BONSAIVIM installation script
  echo -e "$CNT - Installing BONSAIVIM configuration..."
  pushd ~/BONSAIVIM
  chmod +x symlink_nvim_clean.sh
  ./symlink_nvim_clean.sh
  popd

}

function update_grub_sddm() {
  # SDDM
  sudo cp -r ~/archinstall/dotfiles/etc/sddm.conf /etc/
  sudo cp -r ~/archinstall/dotfiles/usr/share/sddm/themes/bonsai/ /usr/share/sddm/themes/
  # Grub
  sudo cp -r ~/archinstall/dotfiles/etc/default/grub /etc/default/
  sudo cp -r ~/archinstall/dotfiles/usr/share/grub/themes/* /boot/grub/themes/
  # find the Nvidia GPU
  if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
    ISNVIDIA=true
  else
    ISNVIDIA=false
  fi
  # Setup Nvidia if it was found
  if [[ "$ISNVIDIA" == true ]]; then
    # Additional for GRUB users
    # Check if /etc/default/grub exists
    if [ -f /etc/default/grub ]; then
      # Check if nvidia-drm.modeset=1 is present
      if ! sudo grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
        # Add nvidia-drm.modeset=1 to GRUB_CMDLINE_LINUX_DEFAULT
        sudo sed -i -e 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia-drm.modeset=1"/' /etc/default/grub
        echo "nvidia-drm.modeset=1 added to /etc/default/grub" 2>&1 | tee -a "$INSTLOG"
      fi

      # Check if nvidia_drm.fbdev=1 is present
      if ! sudo grep -q "nvidia_drm.fbdev=1" /etc/default/grub; then
        # Add nvidia_drm.fbdev=1 to GRUB_CMDLINE_LINUX_DEFAULT
        sudo sed -i -e 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia_drm.fbdev=1"/' /etc/default/grub
        echo "nvidia_drm.fbdev=1 added to /etc/default/grub" 2>&1 | tee -a "$INSTLOG"
      fi
      # Regenerate GRUB configuration if any changes were made
      if sudo grep -q "nvidia-drm.modeset=1" /etc/default/grub || sudo grep -q "nvidia_drm.fbdev=1" /etc/default/grub; then
        sudo grub-mkconfig -o /boot/grub/grub.cfg
      fi
    else
      echo "/etc/default/grub does not exist"
    fi
  fi
  sudo fdisk -l
  echo " "
  read -p 'Enter disk name for installation: ' disk
  deviceUUID=$(sudo blkid -s UUID -o value /dev/${disk})
  variable="GRUB_CMDLINE_LINUX="""
  variable_changed="GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${deviceUUID}:MainPart:allow-discards\""
  sudo sed -i "/^$variable/ c$variable_changed" /etc/default/grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
}

clear
echo -ne "
--------------------------------------------------------------------------------------
 █████╗ ██████╗  ██████╗██╗  ██╗██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     
██╔══██╗██╔══██╗██╔════╝██║  ██║██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     
███████║██████╔╝██║     ███████║██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     
██╔══██║██╔══██╗██║     ██╔══██║██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     
██║  ██║██║  ██║╚██████╗██║  ██║██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
                                                                                      
---------------------------------------------------------------------------------------
"
echo ""
echo "Select Action:"
echo "  1)Install Arch Minimal"
echo "  2)Install Hyprland"
echo "  3)Restore Dotfiles"
echo "  4)Update Grub/SDDM"
read -p 'Selection: ' n
case $n in
  1)
    pacman_init
    btrfs_format
    base_config
    ;;
  2)
    i3_install
    ;;
  3)
    restore_dotfiles
    ;;
  4)
    update_grub_sddm
    ;;
  *) echo "invalid option" ;;
esac
