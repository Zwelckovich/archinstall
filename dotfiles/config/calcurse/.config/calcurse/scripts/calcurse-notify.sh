#!/bin/bash
# ╭─────────────────────────────────────────────────────────────────────────────╮
# │ 🌱 BONSAI Calcurse Notification Script                                      │
# │ Desktop notifications for appointments and todos using notify-send          │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# BONSAI Colors for terminal output (if needed for debugging)
BONSAI_GREEN="\e[38;2;124;152;133m"
BONSAI_BLUE="\e[38;2;130;164;199m"
BONSAI_YELLOW="\e[38;2;199;168;130m"
BONSAI_RED="\e[38;2;199;130;137m"
RESET="\e[0m"

# Configuration
CALCURSE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/calcurse"
CALCURSE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/calcurse"
CHECK_INTERVAL=60  # Check every minute
NOTIFY_BEFORE=(15 5)  # Notify X minutes before appointment

# Log file for debugging
LOG_FILE="/tmp/calcurse-notify.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Function to get upcoming appointments
get_appointments() {
    local minutes_ahead=$1
    local end_time=$(date -d "+${minutes_ahead} minutes" '+%H:%M')
    
    # Use calcurse to get appointments for today
    calcurse --day --format-apt='%S|%m|%N' 2>/dev/null | \
    while IFS='|' read -r start_time message note; do
        # Check if appointment is within notification window
        if [[ -n "$start_time" && -n "$message" ]]; then
            echo "${start_time}|${message}|${note}"
        fi
    done
}

# Function to check todos with deadlines
check_todos() {
    # Get todos with deadlines approaching
    calcurse --todo --format-todo='%p|%m|%d' 2>/dev/null | \
    while IFS='|' read -r priority message deadline; do
        if [[ -n "$deadline" ]]; then
            # Check if deadline is today or overdue
            deadline_date=$(date -d "$deadline" '+%Y-%m-%d' 2>/dev/null)
            today=$(date '+%Y-%m-%d')
            
            if [[ "$deadline_date" == "$today" ]]; then
                echo "today|${priority}|${message}"
            elif [[ "$deadline_date" < "$today" ]]; then
                echo "overdue|${priority}|${message}"
            fi
        fi
    done
}

# Function to send notification
send_notification() {
    local urgency="$1"
    local title="$2"
    local message="$3"
    local icon="$4"
    
    # Send notification using notify-send
    notify-send -u "$urgency" -i "$icon" "$title" "$message"
    
    # Log the notification
    log_message "Sent notification: [$urgency] $title - $message"
}

# Function to format time remaining
format_time_remaining() {
    local minutes=$1
    
    if [[ $minutes -eq 0 ]]; then
        echo "now"
    elif [[ $minutes -eq 1 ]]; then
        echo "in 1 minute"
    elif [[ $minutes -lt 60 ]]; then
        echo "in $minutes minutes"
    else
        local hours=$((minutes / 60))
        local remaining_minutes=$((minutes % 60))
        if [[ $hours -eq 1 ]]; then
            echo "in 1 hour"
        else
            echo "in $hours hours"
        fi
    fi
}

# Function to check for appointment notifications
check_appointments() {
    local current_time=$(date '+%H:%M')
    local current_datetime=$(date '+%Y-%m-%d %H:%M')
    
    # Check for each notification window
    for minutes_before in "${NOTIFY_BEFORE[@]}"; do
        # Get appointments in the next time window
        calcurse --next 24 --format-apt='%S|%m|%N' 2>/dev/null | \
        while IFS='|' read -r apt_time apt_title apt_note; do
            if [[ -n "$apt_time" && -n "$apt_title" ]]; then
                # Calculate time until appointment
                apt_datetime="$(date '+%Y-%m-%d') $apt_time"
                apt_timestamp=$(date -d "$apt_datetime" '+%s' 2>/dev/null)
                current_timestamp=$(date '+%s')
                
                if [[ -n "$apt_timestamp" ]]; then
                    time_diff=$(( (apt_timestamp - current_timestamp) / 60 ))
                    
                    # Check if we should notify for this appointment
                    if [[ $time_diff -eq $minutes_before ]]; then
                        time_str=$(format_time_remaining $minutes_before)
                        
                        # Determine urgency based on time remaining
                        if [[ $minutes_before -le 5 ]]; then
                            urgency="critical"
                            icon="alarm"
                            title="⏰ Appointment Alert!"
                        else
                            urgency="normal"
                            icon="appointment-soon"
                            title="📅 Upcoming Appointment"
                        fi
                        
                        # Build message
                        message="$apt_title"
                        message="$message\n🕐 Starting $time_str at $apt_time"
                        
                        if [[ -n "$apt_note" ]]; then
                            message="$message\n📝 $apt_note"
                        fi
                        
                        send_notification "$urgency" "$title" "$message" "$icon"
                    fi
                fi
            fi
        done
    done
}

# Function to check for todo deadlines
check_todo_deadlines() {
    check_todos | while IFS='|' read -r status priority message; do
        if [[ "$status" == "today" ]]; then
            # Todo due today
            title="✅ Todo Due Today"
            urgency="normal"
            icon="task-due"
            
            # Add priority indicator
            case "$priority" in
                1|2|3) message="[HIGH] $message" ;;
                4|5|6) message="[MED] $message" ;;
                7|8|9) message="[LOW] $message" ;;
            esac
            
            send_notification "$urgency" "$title" "$message" "$icon"
            
        elif [[ "$status" == "overdue" ]]; then
            # Overdue todo
            title="⚠️ Overdue Todo!"
            urgency="critical"
            icon="task-past-due"
            
            send_notification "$urgency" "$title" "$message" "$icon"
        fi
    done
}

# Function to send daily agenda summary
send_daily_agenda() {
    local hour=$(date '+%H')
    local minute=$(date '+%M')
    
    # Send daily agenda at 8:00 AM (configurable)
    if [[ "$hour" == "08" && "$minute" == "00" ]]; then
        # Count appointments and todos for today
        apt_count=$(calcurse --day --format-apt='%m' 2>/dev/null | grep -c .)
        todo_count=$(calcurse --todo --format-todo='%m' 2>/dev/null | grep -c .)
        
        title="🌱 BONSAI Daily Agenda"
        message="Today you have:\n"
        
        if [[ $apt_count -gt 0 ]]; then
            message="${message}📅 $apt_count appointment(s)\n"
        fi
        
        if [[ $todo_count -gt 0 ]]; then
            message="${message}✅ $todo_count todo(s)\n"
        fi
        
        if [[ $apt_count -eq 0 && $todo_count -eq 0 ]]; then
            message="${message}🎋 Clear schedule - enjoy your day!"
        else
            message="${message}\nPress Super+C to view in calcurse"
        fi
        
        send_notification "low" "$title" "$message" "calendar"
    fi
}

# Main notification loop
main() {
    log_message "Calcurse notification daemon started"
    
    # Check if calcurse data exists
    if [[ ! -d "$CALCURSE_DIR" ]]; then
        log_message "Calcurse data directory not found. Creating..."
        mkdir -p "$CALCURSE_DIR"
    fi
    
    # Main loop
    while true; do
        # Check for appointment notifications
        check_appointments
        
        # Check for todo deadline notifications (once per hour)
        minute=$(date '+%M')
        if [[ "$minute" == "00" ]]; then
            check_todo_deadlines
            send_daily_agenda
        fi
        
        # Sleep until next check
        sleep $CHECK_INTERVAL
    done
}

# Handle termination gracefully
trap 'log_message "Calcurse notification daemon stopped"; exit 0' SIGTERM SIGINT

# Start the daemon
main