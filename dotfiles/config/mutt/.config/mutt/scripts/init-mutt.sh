#!/bin/bash
# ╭─────────────────────────────────────────────────────────────────────────────╮
# │ 🌱 BONSAI Mutt Initialization                                               │
# │ Ensures all required directories exist                                      │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# Create cache directories for performance
mkdir -p ~/.cache/mutt/{headers,messages}

# Create accounts directory for configurations
mkdir -p ~/.config/mutt/accounts

# Create a temp directory for HTML viewing
mkdir -p ~/.cache/mutt/temp

# Ensure scripts are executable
if [ -d ~/.config/mutt/scripts ]; then
    chmod +x ~/.config/mutt/scripts/*.sh 2>/dev/null
fi

# Success indicator (silent by default)
[ "$1" = "-v" ] && echo "✓ Mutt directories initialized"