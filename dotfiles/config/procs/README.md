# 🌱 BONSAI procs Configuration

## Overview

`procs` is a modern replacement for `ps` written in Rust, providing a more colorful and informative process viewer with BONSAI aesthetics.

## Features

- **BONSAI Color Scheme**: Dark zen color palette for comfortable viewing
- **Minimal Display**: Shows only essential process information
- **Smart Highlighting**: CPU usage color-coded by percentage
- **Vi-like Navigation**: Familiar keyboard shortcuts
- **Docker Integration**: View container processes seamlessly

## Installation

The procs package is automatically installed via the BONSAI installer:

```bash
# Installed automatically in install_bonsai.sh
yay -S procs
```

## Configuration

The configuration is automatically deployed via stow:

```bash
# Deploy procs configuration
stow -v 1 -t ~/ -d ~/archinstall/dotfiles/config procs
```

## Usage

### Basic Commands

```bash
# View all processes
procs

# Search for a specific process
procs firefox

# View process tree
procs --tree

# Watch processes (update every 2 seconds)
procs --watch

# Sort by memory usage
procs --sortd mem

# Sort by CPU usage
procs --sortd cpu

# Show only processes of current user
procs --uid $(id -u)

# Show Docker container processes
procs --docker
```

### Interactive Key Bindings

When running `procs` interactively:

| Key | Action |
|-----|--------|
| `q` | Quit |
| `/` | Search |
| `n` | Next search result |
| `N` | Previous search result |
| `k` | Kill selected process |
| `t` | Toggle tree view |
| `Space` | Tag/untag process |
| `Enter` | Show process details |
| `Tab` | Change sort column |
| `<` / `>` | Change sort order |
| `h`/`j`/`k`/`l` | Vi-like navigation |

### Column Information

The BONSAI configuration displays these columns:

- **PID**: Process ID (Blue)
- **User**: Process owner (Green)
- **CPU%**: CPU usage (Color-coded by percentage)
- **MEM%**: Memory percentage (Color-coded by percentage)
- **CPU Time**: Total CPU time used (Cyan)
- **Multi**: Additional process info (Color-coded by unit)
- **Command**: Process command (White)

### CPU Usage Color Coding

CPU usage is color-coded for quick identification:

- 🟢 **0-30%**: Green (Good)
- 🔵 **30-60%**: Blue (Normal)
- 🟡 **60-80%**: Yellow (Warning)
- 🟨 **80-90%**: Bright Yellow (High)
- 🔴 **90-100%**: Red (Critical)

### Process States

Process states are color-coded:

- **R - Running**: Bright Green (Active process)
- **S - Sleeping**: Yellow (Idle, waiting)
- **D - Uninterruptible Sleep**: Red (Disk I/O)
- **T - Stopped**: Cyan (Stopped by signal)
- **Z - Zombie**: Magenta (Dead but not reaped)
- **X - Dead**: Magenta (Terminated)
- **K - Wakekill**: Blue (Waking to die)
- **W - Paging**: Cyan (Paging state)
- **P - Parked**: Yellow (Parked thread)

## Advanced Usage

### Custom Filters

```bash
# Show only processes using more than 10% CPU
procs | awk '$3 > 10'

# Show only root processes
procs --uid 0

# Show processes with specific state
procs | grep -E 'Run|Sleep'
```

### Integration with Other Tools

```bash
# Kill all processes matching a pattern
procs firefox | awk '{print $1}' | xargs kill

# Monitor high CPU processes
watch -n 1 'procs --sortd cpu | head -20'

# Export to file with timestamp
procs > ~/process_snapshot_$(date +%Y%m%d_%H%M%S).txt
```

### Docker Container Monitoring

```bash
# View all Docker processes
procs --docker

# View specific container processes
docker ps -q | xargs -I {} procs --docker {}
```

## BONSAI Design Principles

The configuration follows BONSAI principles:

1. **Minimal Display**: Shows only essential columns
2. **Purposeful Colors**: Each color conveys meaning
3. **Dark Zen Aesthetic**: Easy on the eyes for extended use
4. **Smart Defaults**: Sensible configuration out of the box

## Troubleshooting

### Colors Not Displaying

Ensure your terminal supports 256 colors:

```bash
echo $TERM  # Should show xterm-256color or similar
```

### Docker Processes Not Showing

Check Docker permissions:

```bash
# Add user to docker group
sudo usermod -aG docker $USER
# Log out and back in for changes to take effect
```

### Configuration Not Loading

Verify configuration location:

```bash
# Check if config exists
ls -la ~/.config/procs/config.toml

# Manually specify config if needed
procs --config ~/.config/procs/config.toml
```

## Comparison with Traditional ps

| Feature | ps | procs |
|---------|----|----|
| Color output | ❌ | ✅ |
| Tree view | Limited | ✅ Full |
| Docker integration | ❌ | ✅ |
| Interactive mode | ❌ | ✅ |
| Human-readable sizes | Limited | ✅ |
| Search capability | ❌ | ✅ |
| Vi-like navigation | ❌ | ✅ |

## Tips & Tricks

1. **Quick Process Kill**: Use `/` to search, `Space` to tag multiple processes, then `k` to kill all tagged
2. **Monitor Specific App**: `procs --watch firefox` to monitor Firefox processes
3. **Resource Hogs**: `procs --sortd mem` to find memory-hungry processes
4. **Tree Investigation**: `procs --tree` to understand process relationships
5. **Export for Analysis**: Pipe to `jq` or `awk` for advanced filtering

## Customization

To modify the configuration, edit:

```
~/.config/procs/config.toml
```

After changes, restart procs to apply new settings.

---

*Part of the BONSAI dotfiles collection - Minimal • Purposeful • Beautiful* 🌱