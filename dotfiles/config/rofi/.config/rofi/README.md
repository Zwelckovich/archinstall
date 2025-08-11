# 🌱 BONSAI Rofi Configuration

Minimal, purposeful rofi launcher with BONSAI dark zen aesthetic and vim-style keybindings.

## Features

- **Single Purpose**: Application launcher only (drun mode)
- **BONSAI Colors**: Dark background with sage green accents
- **Vim-style Navigation**: Use Ctrl+j/k for movement
- **Clean Design**: No clutter, just what's needed

## Structure

```
.config/rofi/
├── bin/
│   └── launcher        # Main launcher script
└── config/
    └── launcher.rasi   # BONSAI theme configuration
```

## Usage

Run the launcher:
```bash
~/.config/rofi/bin/launcher
```

## Keybindings (Vim-inspired)

### Navigation
- `Ctrl+j` / `Alt+j` / `Down`: Move down
- `Ctrl+k` / `Alt+k` / `Up`: Move up
- `Ctrl+g`: Go to first item
- `Ctrl+Shift+g`: Go to last item
- `Ctrl+m` / `Enter`: Launch selected item

### Scrolling
- `Ctrl+Shift+u` / `Page_Up`: Page up
- `Ctrl+Shift+d` / `Page_Down`: Page down

### Search Box Editing
- `Ctrl+h` / `BackSpace`: Delete character backward
- `Ctrl+d` / `Delete`: Delete character forward
- `Ctrl+u`: Clear to beginning of line
- `Ctrl+Shift+k`: Clear to end of line
- `Ctrl+a` / `Home`: Move to beginning of line
- `Ctrl+e` / `End`: Move to end of line
- `Ctrl+b` / `Left`: Move cursor left
- `Ctrl+f` / `Right`: Move cursor right
- `Alt+b`: Move word backward
- `Alt+w`: Move word forward

### Tab Navigation
- `Tab`: Next element
- `Shift+Tab`: Previous element
- `Ctrl+Tab`: Next mode (drun → run → ssh)
- `Ctrl+Shift+Tab`: Previous mode

### Exit
- `ESC`: Quit rofi
- `Alt+q`: Quit rofi (vim-style alternative)

## Notes

- **Type normally** to search - all letters work for filtering
- Vim keybindings use Ctrl/Alt modifiers to avoid conflicts with typing
- The launcher keeps rofi simple and minimal in BONSAI spirit

## Theme

Uses the BONSAI color palette:
- Background: Deep dark (#151922)
- Text: Light gray (#e6e8eb)
- Selection: Sage green (#7c9885)
- Borders: Subtle (#2d3441)

Font: JetBrains Mono 10