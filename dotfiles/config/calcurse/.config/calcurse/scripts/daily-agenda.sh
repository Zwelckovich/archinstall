#!/bin/bash
# ╭─────────────────────────────────────────────────────────────────────────────╮
# │ 🌱 BONSAI Calcurse Daily Agenda Script                                      │
# │ Display today's agenda in a notification or terminal                        │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# BONSAI Colors
BONSAI_GREEN="\e[38;2;124;152;133m"
BONSAI_BLUE="\e[38;2;130;164;199m"
BONSAI_YELLOW="\e[38;2;199;168;130m"
BONSAI_RED="\e[38;2;199;130;137m"
BONSAI_PURPLE="\e[38;2;152;130;199m"
BONSAI_TEXT="\e[38;2;230;232;235m"
BONSAI_MUTED="\e[38;2;139;146;165m"
RESET="\e[0m"

# Function to format agenda for terminal
format_terminal_agenda() {
    echo -e "${BONSAI_GREEN}╭─────────────────────────────────────────────────────────────────╮${RESET}"
    echo -e "${BONSAI_GREEN}│                 🌱 BONSAI Daily Agenda                         │${RESET}"
    echo -e "${BONSAI_GREEN}│                 $(date '+%A, %B %d, %Y')                      │${RESET}"
    echo -e "${BONSAI_GREEN}╰─────────────────────────────────────────────────────────────────╯${RESET}"
    echo
    
    # Get appointments for today
    echo -e "${BONSAI_BLUE}📅 Today's Appointments:${RESET}"
    appointments=$(calcurse --day --format-apt='%S - %E: %m %N' 2>/dev/null)
    
    if [[ -z "$appointments" ]]; then
        echo -e "  ${BONSAI_MUTED}No appointments scheduled${RESET}"
    else
        echo "$appointments" | while IFS= read -r line; do
            echo -e "  ${BONSAI_TEXT}• $line${RESET}"
        done
    fi
    echo
    
    # Get todos
    echo -e "${BONSAI_YELLOW}✅ Todo List:${RESET}"
    todos=$(calcurse --todo --format-todo='[%p] %m' 2>/dev/null)
    
    if [[ -z "$todos" ]]; then
        echo -e "  ${BONSAI_MUTED}No todos${RESET}"
    else
        echo "$todos" | while IFS= read -r line; do
            # Color-code by priority
            if [[ "$line" =~ ^\[1\]|\[2\]|\[3\] ]]; then
                echo -e "  ${BONSAI_RED}• $line${RESET}"
            elif [[ "$line" =~ ^\[4\]|\[5\]|\[6\] ]]; then
                echo -e "  ${BONSAI_YELLOW}• $line${RESET}"
            else
                echo -e "  ${BONSAI_TEXT}• $line${RESET}"
            fi
        done
    fi
    echo
    
    # Summary
    apt_count=$(echo "$appointments" | grep -c '^' 2>/dev/null || echo 0)
    todo_count=$(echo "$todos" | grep -c '^' 2>/dev/null || echo 0)
    
    echo -e "${BONSAI_GREEN}─────────────────────────────────────────────────────────────────${RESET}"
    echo -e "${BONSAI_PURPLE}Summary: $apt_count appointment(s), $todo_count todo(s)${RESET}"
    echo -e "${BONSAI_MUTED}Press Super+C to open calcurse${RESET}"
}

# Function to send agenda as notification
send_notification_agenda() {
    # Get counts
    apt_count=$(calcurse --day --format-apt='%m' 2>/dev/null | grep -c . || echo 0)
    todo_count=$(calcurse --todo --format-todo='%m' 2>/dev/null | grep -c . || echo 0)
    
    # Build notification message
    title="🌱 Daily Agenda - $(date '+%A, %b %d')"
    message=""
    
    # Add appointments
    if [[ $apt_count -gt 0 ]]; then
        message="📅 $apt_count appointment(s) today\n"
        
        # Get first 3 appointments
        appointments=$(calcurse --day --format-apt='%S: %m' 2>/dev/null | head -3)
        while IFS= read -r apt; do
            message="${message}  • $apt\n"
        done <<< "$appointments"
        
        if [[ $apt_count -gt 3 ]]; then
            message="${message}  ...$((apt_count - 3)) more\n"
        fi
        message="${message}\n"
    fi
    
    # Add todos
    if [[ $todo_count -gt 0 ]]; then
        message="${message}✅ $todo_count todo(s) pending\n"
        
        # Get high priority todos
        high_priority=$(calcurse --todo --format-todo='[%p] %m' 2>/dev/null | grep '^\[1\]\|\[2\]\|\[3\]' | head -3)
        if [[ -n "$high_priority" ]]; then
            while IFS= read -r todo; do
                message="${message}  • $todo\n"
            done <<< "$high_priority"
        fi
    fi
    
    # Empty day message
    if [[ $apt_count -eq 0 && $todo_count -eq 0 ]]; then
        message="🎋 Clear schedule today!\nEnjoy your peaceful day."
    fi
    
    # Send notification
    notify-send -i "calendar" "$title" "$message"
}

# Main execution
case "${1:-terminal}" in
    notify|notification)
        send_notification_agenda
        ;;
    terminal|*)
        format_terminal_agenda
        ;;
esac