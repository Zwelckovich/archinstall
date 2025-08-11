#!/bin/bash
# ╭─────────────────────────────────────────────────────────────────────────────╮
# │ 🌱 BONSAI Image Extractor for Mutt                                          │
# │ Extract and view all images from email                                      │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# BONSAI Colors
BONSAI_GREEN="\e[38;2;124;152;133m"
BONSAI_BLUE="\e[38;2;130;164;199m"
BONSAI_YELLOW="\e[38;2;199;168;130m"
BONSAI_TEXT="\e[38;2;230;232;235m"
RESET="\e[0m"

# Create temporary directory
tmpdir=$(mktemp -d /tmp/mutt-images-XXXXXX)

echo -e "${BONSAI_GREEN}🌱 Extracting images...${RESET}"

# Save email content to temp file
tmpmail="$tmpdir/email.eml"
cat > "$tmpmail"

# Extract images using munpack or ripmime
if command -v munpack &> /dev/null; then
    cd "$tmpdir"
    munpack -q "$tmpmail" 2>/dev/null
elif command -v ripmime &> /dev/null; then
    ripmime -i "$tmpmail" -d "$tmpdir" 2>/dev/null
else
    echo -e "${BONSAI_YELLOW}⚠ Neither munpack nor ripmime found${RESET}"
    echo -e "${BONSAI_TEXT}Install one with: yay -S mpack${RESET}"
    exit 1
fi

# Find all image files
images=$(find "$tmpdir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.webp" \) 2>/dev/null)

if [ -z "$images" ]; then
    echo -e "${BONSAI_YELLOW}No images found in this email${RESET}"
else
    count=$(echo "$images" | wc -l)
    echo -e "${BONSAI_BLUE}Found ${count} image(s)${RESET}"
    
    # Display images with feh in gallery mode
    echo "$images" | xargs feh -F -Z -. 2>/dev/null &
    
    echo -e "${BONSAI_GREEN}✓ Images opened in feh${RESET}"
    echo -e "${BONSAI_TEXT}Use arrow keys to navigate, 'q' to quit${RESET}"
fi

# Clean up after delay
(sleep 60 && rm -rf "$tmpdir") &