#!/bin/bash
# ╭─────────────────────────────────────────────────────────────────────────────╮
# │ 🌱 BONSAI Calcurse ICS Import Script                                        │
# │ Import calendar invites from mutt attachments                               │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# BONSAI Colors
BONSAI_GREEN="\e[38;2;124;152;133m"
BONSAI_BLUE="\e[38;2;130;164;199m"
BONSAI_YELLOW="\e[38;2;199;168;130m"
BONSAI_RED="\e[38;2;199;130;137m"
RESET="\e[0m"

# Check if file is provided
if [ $# -eq 0 ]; then
    echo -e "${BONSAI_RED}Error: No ICS file provided${RESET}"
    echo "Usage: $0 <ics-file>"
    exit 1
fi

ICS_FILE="$1"

# Check if file exists
if [ ! -f "$ICS_FILE" ]; then
    echo -e "${BONSAI_RED}Error: File not found: $ICS_FILE${RESET}"
    exit 1
fi

# Check if it's an ICS file
if [[ ! "$ICS_FILE" =~ \.ics$ ]] && ! grep -q "BEGIN:VCALENDAR" "$ICS_FILE" 2>/dev/null; then
    echo -e "${BONSAI_YELLOW}Warning: File doesn't appear to be an ICS file${RESET}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Import the ICS file into calcurse
echo -e "${BONSAI_BLUE}→ Importing calendar invite...${RESET}"

# Use calcurse import function
if calcurse -i "$ICS_FILE" 2>/dev/null; then
    echo -e "${BONSAI_GREEN}✓ Calendar invite imported successfully!${RESET}"
    
    # Show summary of imported events
    echo -e "\n${BONSAI_BLUE}Imported events:${RESET}"
    
    # Parse basic info from ICS file
    grep -E "^(SUMMARY|DTSTART|LOCATION):" "$ICS_FILE" | while read -r line; do
        case "$line" in
            SUMMARY:*)
                echo -e "  ${BONSAI_GREEN}Event:${RESET} ${line#SUMMARY:}"
                ;;
            DTSTART:*)
                # Try to parse date
                date_str="${line#DTSTART:}"
                date_str="${date_str//[^0-9T]/}"
                if [[ -n "$date_str" ]]; then
                    echo -e "  ${BONSAI_BLUE}Date:${RESET} $date_str"
                fi
                ;;
            LOCATION:*)
                echo -e "  ${BONSAI_YELLOW}Location:${RESET} ${line#LOCATION:}"
                ;;
        esac
    done
    
    # Send notification
    if command -v notify-send &> /dev/null; then
        notify-send -i "calendar" "📅 Calendar Invite Imported" "Event has been added to calcurse"
    fi
    
    echo -e "\n${BONSAI_GREEN}Press Super+C to view in calcurse${RESET}"
else
    echo -e "${BONSAI_RED}✗ Failed to import calendar invite${RESET}"
    echo -e "${BONSAI_YELLOW}Please check if the ICS file is valid${RESET}"
    exit 1
fi