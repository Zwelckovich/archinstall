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

# Create local mail directories if using offline IMAP
if [ -d ~/.mail ]; then
    # For each mail account directory
    for account_dir in ~/.mail/*/; do
        if [ -d "$account_dir" ]; then
            # Create standard folders if they don't exist
            mkdir -p "$account_dir/INBOX"
            mkdir -p "$account_dir/Sent"
            mkdir -p "$account_dir/Drafts"
            mkdir -p "$account_dir/Trash"
            mkdir -p "$account_dir/Archive"
            
            # Create Gmail-specific folders if it's a Gmail account
            if [[ "$account_dir" == *"gmail"* ]] || [[ "$account_dir" == *"@gmail.com"* ]]; then
                mkdir -p "$account_dir/[Gmail]/Sent Mail"
                mkdir -p "$account_dir/[Gmail]/Drafts"
                mkdir -p "$account_dir/[Gmail]/Trash"
                mkdir -p "$account_dir/[Gmail]/All Mail"
            fi
        fi
    done
fi

# Ensure scripts are executable
if [ -d ~/.config/mutt/scripts ]; then
    chmod +x ~/.config/mutt/scripts/*.sh 2>/dev/null
fi

# Success indicator (silent by default)
[ "$1" = "-v" ] && echo "✓ Mutt directories initialized"