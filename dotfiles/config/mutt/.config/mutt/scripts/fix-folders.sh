#!/bin/bash
# ╭─────────────────────────────────────────────────────────────────────────────╮
# │ 🌱 BONSAI Mutt Folder Fix                                                   │
# │ Creates missing mail folders to prevent Fcc errors                         │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# BONSAI Colors
BONSAI_GREEN="\e[38;2;124;152;133m"
BONSAI_BLUE="\e[38;2;130;164;199m"
BONSAI_YELLOW="\e[38;2;199;168;130m"
BONSAI_TEXT="\e[38;2;230;232;235m"
RESET="\e[0m"

echo -e "${BONSAI_GREEN}🌱 BONSAI Mutt Folder Fix${RESET}\n"

# Check if using offline IMAP (mbsync)
if [ -d ~/.mail ]; then
    echo -e "${BONSAI_BLUE}→ Creating local mail folders...${RESET}"
    
    for account_dir in ~/.mail/*/; do
        if [ -d "$account_dir" ]; then
            account_name=$(basename "$account_dir")
            echo -e "${BONSAI_TEXT}  Processing: $account_name${RESET}"
            
            # Create standard folders
            mkdir -p "$account_dir/INBOX"
            mkdir -p "$account_dir/Sent"
            mkdir -p "$account_dir/Drafts"
            mkdir -p "$account_dir/Trash"
            mkdir -p "$account_dir/Archive"
            
            # Gmail-specific folders
            if [[ "$account_name" == *"gmail"* ]] || [[ "$account_name" == *"googlemail"* ]]; then
                mkdir -p "$account_dir/[Gmail]/Sent Mail"
                mkdir -p "$account_dir/[Gmail]/Drafts"
                mkdir -p "$account_dir/[Gmail]/Trash"
                mkdir -p "$account_dir/[Gmail]/All Mail"
                mkdir -p "$account_dir/[Gmail]/Spam"
                mkdir -p "$account_dir/[Gmail]/Starred"
                mkdir -p "$account_dir/[Gmail]/Important"
            fi
            
            # T-Online specific folders (German)
            if [[ "$account_name" == *"t-online"* ]]; then
                mkdir -p "$account_dir/Gesendet"
                mkdir -p "$account_dir/Entwürfe"
                mkdir -p "$account_dir/Papierkorb"
            fi
            
            # Outlook/Hotmail specific
            if [[ "$account_name" == *"outlook"* ]] || [[ "$account_name" == *"hotmail"* ]]; then
                mkdir -p "$account_dir/Sent Items"
                mkdir -p "$account_dir/Deleted Items"
                mkdir -p "$account_dir/Junk Email"
            fi
        fi
    done
    
    echo -e "${BONSAI_GREEN}✓ Local folders created${RESET}"
else
    echo -e "${BONSAI_YELLOW}⚠ No local mail directory found${RESET}"
    echo -e "${BONSAI_TEXT}  If using IMAP without offline sync, folders are managed by server${RESET}"
fi

# Create fallback sent-mail file in home directory
touch ~/sent-mail
echo -e "${BONSAI_GREEN}✓ Fallback sent-mail file created${RESET}"

# Create mutt cache directories
mkdir -p ~/.cache/mutt/{headers,messages,temp}
echo -e "${BONSAI_GREEN}✓ Cache directories verified${RESET}"

echo -e "\n${BONSAI_GREEN}✓ All folders fixed!${RESET}"
echo -e "${BONSAI_TEXT}Restart mutt to apply changes${RESET}"