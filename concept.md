# 🌱 BONSAI Arch Linux Installer - Concept Document

## Project Vision

**BONSAI Arch Linux Installer** is an enhanced installation script that transforms the Arch Linux installation experience through thoughtful design, intuitive interaction, and beautiful aesthetics while maintaining the power and flexibility that Arch users expect.

## Core Philosophy

- **Minimal**: Only essential features, no bloat
- **Purposeful**: Every enhancement serves a clear user need  
- **Beautiful**: BONSAI aesthetics throughout the experience
- **Reliable**: Preserve all working installation logic

## Primary Goals

1. **Simplify Critical Decisions**: Make disk selection and partition configuration intuitive
2. **Visual Clarity**: Use BONSAI colors and styling for better readability
3. **Reduce Errors**: Interactive menus prevent typos and invalid selections
4. **Flexibility**: Support both encrypted and non-encrypted installations seamlessly

## Core Features

### 1. BONSAI Visual Identity
- Consistent color palette using BONSAI theme colors
- Zen-inspired progress indicators and status messages
- Clean, readable ASCII art for section headers
- Smooth visual feedback for all operations

### 2. Interactive Disk Management
- **Auto-detection**: Automatically discover all available disks
- **Visual Selection**: Menu-driven disk selection (no manual typing)
- **Smart Display**: Show disk sizes, models, and current partitions
- **Partition Intelligence**: Automatically identify correct partitions for boot/root
- **Confirmation Flow**: Clear visual confirmation before destructive operations

### 3. Encryption Flexibility
- **Toggle Option**: Simple menu choice between encrypted/non-encrypted installation
- **Automatic Configuration**: GRUB settings adjusted based on encryption choice
- **Simplified Flow**: No manual partition naming (sda2, nvme0n1p2, etc.)
- **Clear Indicators**: Visual distinction between encrypted/standard paths

### 4. Enhanced User Experience
- **Progress Tracking**: BONSAI-styled progress bars for long operations
- **Step Indicators**: Clear indication of current installation phase
- **Error Recovery**: Graceful handling of common issues
- **Smart Defaults**: Intelligent detection of CPU type, UEFI/BIOS, GPU
- **Unified Menu System**: Consistent interaction patterns throughout

## Technical Implementation

### Color System
```bash
# BONSAI Color Palette
BONSAI_GREEN="\\e[38;2;124;152;133m"     # Primary accent (#7c9885)
BONSAI_BLUE="\\e[38;2;130;164;199m"      # Information (#82a4c7)
BONSAI_YELLOW="\\e[38;2;199;168;130m"    # Warnings (#c7a882)
BONSAI_RED="\\e[38;2;199;130;137m"       # Errors (#c78289)
BONSAI_PURPLE="\\e[38;2;152;130;199m"    # Special (#9882c7)
BONSAI_TEXT="\\e[38;2;230;232;235m"      # Primary text (#e6e8eb)
BONSAI_MUTED="\\e[38;2;139;146;165m"     # Secondary text (#8b92a5)
```

### Menu System
- Utilize `dialog` or pure bash menus with BONSAI styling
- Consistent navigation (arrow keys + enter)
- Visual feedback for selections
- Escape/back functionality throughout

### Disk Detection
- Parse `lsblk` output for comprehensive disk information
- Identify NVMe vs SATA automatically
- Handle partition naming differences seamlessly
- Show human-readable sizes and descriptions

### Installation Flow
1. Welcome & System Check
2. Disk Selection (interactive)
3. Encryption Choice (toggle)
4. Partition & Format
5. Base System Installation
6. System Configuration
7. Bootloader Setup (automatic based on choices)
8. User Creation
9. Hyprland & Tools Installation
10. Dotfiles Restoration

## Constraints

### Preserved Elements
- **All packages**: No removal of any software from original lists
- **Core commands**: Keep all working installation commands intact
- **Package arrays**: Maintain existing software groupings
- **Installation logic**: Preserve the proven installation sequence

### What We DON'T Change
- Package installation commands
- Partition creation logic  
- BTRFS subvolume structure
- Network configuration
- Core pacstrap operations
- User creation process

## Success Criteria

1. **Zero Manual Typing**: No manual disk/partition name entry required
2. **Visual Consistency**: BONSAI theme applied throughout
3. **Error Prevention**: Interactive menus prevent invalid selections
4. **Encryption Simplicity**: Single toggle for encryption choice
5. **Maintainability**: Clear, well-structured bash code

## File Structure

```
archinstall/
├── install_bonsai.sh     # Enhanced installation script
├── install.sh            # Original script (preserved)
├── concept.md           # This document
└── dotfiles/            # Existing dotfiles (unchanged)
```

## Design Decisions

### Why Interactive Menus?
Manual disk name entry (sda, nvme0n1p2) is error-prone and intimidating. Visual selection with confirmation reduces errors and improves confidence.

### Why Encryption Toggle?
Encryption adds complexity to GRUB configuration. A simple toggle with automatic configuration removes this burden while maintaining security options.

### Why BONSAI Styling?
Consistent visual language reduces cognitive load, makes the installer feel cohesive with the final system, and provides a calming installation experience.

### Why Preserve Everything?
The original script works. We enhance the experience without risking functionality. Every package and command has been tested and proven.

## Implementation Priority

1. **Core Script Structure**: Set up BONSAI colors and functions
2. **Disk Selection Menu**: Interactive disk chooser with details
3. **Encryption Toggle**: Simple on/off with automatic configuration
4. **Progress Indicators**: BONSAI-styled feedback for all operations
5. **Error Handling**: Graceful recovery and clear error messages

## Testing Strategy

- Test on various disk configurations (SATA, NVMe, multiple disks)
- Verify both encrypted and non-encrypted paths
- Ensure GRUB boots correctly in both modes
- Validate all package installations complete successfully
- Confirm dotfiles restoration works as expected

---

This concept document defines the vision for an enhanced Arch Linux installer that maintains reliability while dramatically improving user experience through thoughtful design and BONSAI aesthetics.