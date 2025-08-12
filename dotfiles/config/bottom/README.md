# 🌱 BONSAI bottom Configuration

## Overview

`bottom` (btm) is a cross-platform graphical process/system monitor written in Rust, featuring a customizable terminal UI with BONSAI aesthetics for comfortable system monitoring.

## Features

- **BONSAI Color Scheme**: Dark zen palette optimized for extended viewing
- **Comprehensive Monitoring**: CPU, memory, network, disk, process, and temperature tracking
- **Interactive Interface**: Mouse and keyboard support with vi-like keybindings
- **Smart Layouts**: Customizable widget arrangement for optimal information display
- **GPU Support**: Monitor GPU usage when available
- **Process Management**: Kill, search, and sort processes efficiently

## Installation

The bottom package is automatically installed via the BONSAI installer:

```bash
# Installed automatically in install_bonsai.sh
yay -S bottom
```

## Configuration

The configuration is automatically deployed via stow:

```bash
# Deploy bottom configuration
stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config bottom
```

## Usage

### Basic Commands

```bash
# Launch bottom with default layout
btm

# Launch with basic mode (simplified view)
btm --basic

# Show process tree view
btm --tree

# Focus on a specific widget
btm --default_widget_type proc
btm --default_widget_type cpu
btm --default_widget_type mem
btm --default_widget_type net

# Custom update rate (milliseconds)
btm --rate 500

# Show temperatures in Fahrenheit
btm --fahrenheit

# Disable mouse support
btm --disable_click
```

### Interactive Keybindings

#### General Navigation

| Key | Action |
|-----|--------|
| `q` / `Ctrl-c` | Quit |
| `Esc` | Close dialog/exit search |
| `?` | Show help menu |
| `e` | Expand/collapse widget |
| `f` | Freeze/unfreeze time |
| `Ctrl-r` | Reset all data |

#### Widget Navigation

| Key | Action |
|-----|--------|
| `↑`/`k` | Move up |
| `↓`/`j` | Move down |
| `←`/`h` | Move left |
| `→`/`l` | Move right |
| `Tab` | Next widget |
| `Shift-Tab` | Previous widget |
| `1-9` | Jump to widget N |

#### Process Widget

| Key | Action |
|-----|--------|
| `/` | Search processes |
| `Space` | Multi-select for actions |
| `dd` | Kill selected process |
| `c` | Sort by CPU |
| `m` | Sort by memory |
| `p` | Sort by PID |
| `n` | Sort by name |
| `Tab` | Switch between process/sort tabs |
| `I` | Invert sort order |
| `%` | Toggle between values/percentages |
| `t` | Toggle tree view |
| `P` | Toggle grouping by parent |
| `Ctrl-f` / `Page Down` | Scroll down page |
| `Ctrl-b` / `Page Up` | Scroll up page |
| `gg` / `Home` | Jump to top |
| `G` / `End` | Jump to bottom |

#### CPU Widget

| Key | Action |
|-----|--------|
| `a` | Toggle average CPU |
| `Space` | Toggle specific CPU |

#### Memory Widget

| Key | Action |
|-----|--------|
| `%` | Toggle percentages/values |

#### Network Widget

| Key | Action |
|-----|--------|
| `b` | Toggle bits/bytes |
| `l` | Toggle log scale |

#### Search Mode

| Key | Action |
|-----|--------|
| `Tab` | Cycle through search options |
| `Enter` | Confirm search |
| `Alt-c` / `F1` | Toggle case sensitivity |
| `Alt-w` / `F2` | Toggle whole word |
| `Alt-r` / `F3` | Toggle regex |

### Graph Navigation

| Key | Action |
|-----|--------|
| `+` | Zoom in time |
| `-` | Zoom out time |
| `=` | Reset zoom |

## BONSAI Color Coding

### CPU Usage
- 🟢 **Green** (#7c9885): Low usage, healthy system
- 🔵 **Blue** (#82a4c7): Moderate usage
- 🟡 **Yellow** (#c7a882): Higher usage, monitor closely
- 🔴 **Red** (#c78289): High usage, potential bottleneck

### Memory Types
- **RAM**: Blue (#82a4c7) - Active memory
- **Cache**: Yellow (#c7a882) - Cached data
- **Swap**: Purple (#9882c7) - Swap usage
- **ARC**: Teal (#5cc7a8) - Adaptive Replacement Cache

### Network Traffic
- **RX (Download)**: Green (#7c9885) - Incoming data
- **TX (Upload)**: Blue (#82a4c7) - Outgoing data

### Battery Status
- 🔴 **Red**: Low battery (< 20%)
- 🟡 **Yellow**: Medium battery (20-60%)
- 🟢 **Green**: Good battery (> 60%)

## Layout Customization

The default BONSAI layout provides:
- **Top Section**: CPU and Memory/Network graphs side by side
- **Bottom Section**: Process list with comprehensive details

To customize the layout, edit `~/.config/bottom/bottom.toml` and modify the `[[row]]` sections.

### Example Custom Layouts

#### Minimal Process Focus
```toml
[[row]]
  [[row.child]]
  type = "proc"
  default = true
```

#### System Overview
```toml
[[row]]
  [[row.child]]
  type = "cpu"
  [[row.child]]
  type = "mem"
  [[row.child]]
  type = "net"

[[row]]
  [[row.child]]
  type = "disk"
  [[row.child]]
  type = "temp"
```

## Process Management

### Killing Processes

1. Navigate to process with arrow keys or search
2. Press `dd` to open kill dialog
3. Choose signal:
   - `15` (TERM) - Graceful termination
   - `9` (KILL) - Force kill
   - `2` (INT) - Interrupt

### Multi-select Operations

1. Press `Space` to select multiple processes
2. Press `dd` to kill all selected
3. Press `Esc` to clear selection

## Advanced Features

### Filters

The configuration includes smart filters to hide:
- **Disk**: Loop devices, device mapper
- **Mount**: Boot and temporary mounts
- **Network**: Virtual bridges, Docker networks
- **Temperature**: Shows only core sensors

### Data Retention

Default retention is set to 10 minutes. Adjust in config:
```toml
retention = "30m"  # 30 minutes
retention = "1h"   # 1 hour
```

### GPU Monitoring

GPU monitoring is enabled by default. If you have an NVIDIA or AMD GPU:
```bash
# View GPU stats in dedicated widget
btm --default_widget_type gpu
```

## Tips & Tricks

1. **Quick System Check**: `btm --basic` for simplified overview
2. **Process Hunt**: `/` to search, then `dd` to terminate
3. **Resource Hogs**: Sort by CPU (`c`) or Memory (`m`) to find culprits
4. **Network Monitor**: Focus on network widget to track specific connections
5. **Freeze Time**: Press `f` to pause updates for analysis
6. **Export Data**: Use `btm --help` to see export options

## Troubleshooting

### High CPU Usage
- Reduce update rate: `btm --rate 2000` (2 seconds)
- Disable GPU monitoring if not needed
- Use basic mode for lower overhead

### Colors Not Displaying
```bash
# Check terminal color support
echo $TERM  # Should be xterm-256color or similar
```

### Widget Not Showing
- Check layout configuration in `bottom.toml`
- Ensure widget type is spelled correctly
- Verify data source is available (e.g., temperature sensors)

## Comparison with btop

| Feature | btop | bottom |
|---------|------|---------|
| Language | C++ | Rust |
| Performance | Good | Excellent |
| Customization | Limited | Extensive |
| Config Format | Custom | TOML |
| Process Tree | ✅ | ✅ |
| Network Details | Basic | Detailed |
| GPU Support | Limited | ✅ Full |
| Search Regex | ❌ | ✅ |
| Multi-select | ❌ | ✅ |
| Data Export | ❌ | ✅ |

## Customization

To modify colors or behavior, edit:
```
~/.config/bottom/bottom.toml
```

After changes, restart bottom to apply new settings.

---

*Part of the BONSAI dotfiles collection - Minimal • Purposeful • Beautiful* 🌱