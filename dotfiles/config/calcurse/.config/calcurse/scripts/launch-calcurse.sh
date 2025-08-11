#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │ 🌱 BONSAI Calcurse Launcher                                                 │
# │ Ensures calcurse starts with proper configuration                           │
# ╰─────────────────────────────────────────────────────────────────────────────╯

CONFIG_DIR="$HOME/.config/calcurse"
DATA_DIR="$HOME/.local/share/calcurse"

# Ensure directories exist
mkdir -p "$CONFIG_DIR" "$DATA_DIR"

# Check if keys file exists and is valid
if [[ ! -f "$CONFIG_DIR/keys" ]]; then
    echo "⚠️  Keys file not found. Please run stow to install calcurse config."
    exit 1
fi

# Launch calcurse with explicit config directory
exec calcurse -C "$CONFIG_DIR" -D "$DATA_DIR" "$@"