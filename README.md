# Archinstall Catppuccin Style

## Install

```sh
loadkeys de
pacman-key --init
pacman-key --populate archlinux
pacman -Scc
pacman -Syy
pacman -S git reflector
```

Edit your reflector command specific for your needs

```sh
reflector --country Germany --age 12 --protocol https,http --sort rate --save /etc/pacman.d/mirrorlist
```

Clone the archinstall repository

```sh
git clone https://github.com/zwelckovich/archinstall
```

Start the install script

```sh
cd archinstall
sh install.sh
```

Change Monitor Settings

```sh
hyprctl monitors all
```

### Install on MacBook

Before installation:

```sh
rmmod b43 bcma ssb wl
modprobe wl
```

After installation:

```sh
nmcli device wifi list
nmcli device wifi connect SSID_or_BSSID password password
```

## Keybindings

### fzf

| Example                                   | Description                                      |
| ----------------------------------------- | ------------------------------------------------ |
| CTRL-t                                    | Look for files and directories                   |
| CTRL-r                                    | Look through command history                     |
| Enter                                     | Select the item                                  |
| Ctrl-j or Ctrl-n or Down arrow            | Go down one result                               |
| Ctrl-k or Ctrl-p or Up arrow              | Go up one result                                 |
| Tab                                       | Mark a result                                    |
| Shift-Tab                                 | Unmark a result                                  |
| cd \*\*Tab                                | Open up fzf to find directory                    |
| export \*\*Tab                            | Look for env variable to export                  |
| unset \*\*Tab                             | Look for env variable to unset                   |
| unalias \*\*Tab                           | Look for alias to unalias                        |
| ssh \*\*Tab                               | Look for recently visited host names             |
| kill -9 \*\*Tab                           | Look for process name to kill to get pid         |
| any command (like nvim or code) + \*\*Tab | Look for files & directories to complete command |

### fzf-git

| Keybind | Description                         |
| ------- | ----------------------------------- |
| CTRL-GF | Look for git files with fzf         |
| CTRL-GB | Look for git branches with fzf      |
| CTRL-GT | Look for git tags with fzf          |
| CTRL-GR | Look for git remotes with fzf       |
| CTRL-GH | Look for git commit hashes with fzf |
| CTRL-GS | Look for git stashes with fzf       |
| CTRL-GL | Look for git reflogs with fzf       |
| CTRL-GW | Look for git worktrees with fzf     |
| CTRL-GE | Look for git for-each-ref with fzf  |

### tmux

| Keybind | Description  |
| ------- | ------------ |
| CTRL-A  | Tmux Mod Key |

### zathura

| Keybind        | Description              |
| -------------- | ------------------------ |
| CTRL-R         | Enable/Disable Theme     |
| TAB            | Show Index               |
| F5             | Toggle presentation mode |
| CTRL-LeftClick | Synctex                  |

### LazyVim

| Keybind   | Description                           |
| --------- | ------------------------------------- |
| SPACE-U-S | Enable/Disable spell check            |
| \\-L-L    | Compile TEX-File                      |
| G-C-C     | Comment Line                          |
| ci"       | Change between "" or (){} etc.        |
| c2i"      | Change between second "" or (){} etc. |
| [s        | Previous misspelled word              |
| ]s        | Next misspelled word                  |
| z=        | suggest correct words                 |

## 🌱 BONSAI Applications

### Mutt Email Client

Minimal, purposeful, and beautiful email client configuration with modern HTML/image support.

#### Features

- **BONSAI color theme** matching system aesthetic
- **HTML email rendering** with inline images using w3m
- **Multiple account support** (Gmail, T-Online, Outlook, Yahoo, custom IMAP)
- **Vim-like keybindings** for efficient navigation
- **Secure password storage** using `pass`
- **Smart MIME handling** for attachments, images, PDFs
- **Sidebar navigation** for folder overview
- **URL extraction** with urlscan
- **Calendar integration** with calcurse

#### Quick Start

After running the BONSAI installer, mutt will be configured automatically. To set up your first account:

```bash
~/.config/mutt/scripts/add-account.sh
```

#### Adding Email Accounts

##### Method 1: Interactive Setup (Recommended)

Run the BONSAI account setup wizard:

```bash
~/.config/mutt/scripts/add-account.sh
```

This wizard will:
1. Ask for your email provider (Gmail/T-Online/Outlook/Yahoo/Custom)
2. Securely store your password in `pass`
3. Create the account configuration
4. Set up proper folders (Inbox, Sent, Trash, etc.)
5. Add the account to your muttrc

##### Method 2: Manual Gmail Configuration

1. **Generate an App Password** (required for Gmail):
   - Go to https://myaccount.google.com/security
   - Enable 2-factor authentication
   - Go to "2-Step Verification" → "App passwords"
   - Generate an app password for "Mail"

2. Store password securely:
   ```bash
   pass insert mutt/youremail@gmail.com
   # Enter the app password when prompted
   ```

3. Create account configuration and add to muttrc

#### Key Bindings

##### Writing and Basic Actions
- `m` - Compose new message
- `r` - Reply to sender
- `R` - Reply to all
- `f` - Forward message
- `a` - Add sender to address book

##### Navigation (Vim-like)
- `j/k` - Move down/up in message list
- `gg/G` - Go to first/last message
- `Ctrl-d/u` - Page down/up
- `Enter` - Open message
- `q` - Go back/quit
- `c` - Change to different folder

##### Sidebar
- `Ctrl-n` - Next folder in sidebar
- `Ctrl-p` - Previous folder in sidebar
- `Ctrl-o` - Open selected folder

##### Message Management
- `d` - Delete message
- `u` - Undelete message
- `s` - Save message to folder
- `t` - Tag/untag message
- `;` - Apply next command to tagged messages

##### HTML & Attachments
- `v` - View attachments list
- **In attachment view:**
  - `V` - Open HTML/attachment in browser (Chrome)
  - `I` - Extract all images from email
  - `C` - Import calendar invite (.ics) to calcurse
  - `Enter` - View attachment in mutt
  - `s` - Save attachment to disk
  - `q` - Exit attachment view
- `Ctrl-b` - Extract and browse URLs from message
- `Ctrl-c` - Open calcurse calendar from mutt

##### Searching
- `/` - Search in current folder
- `n` - Next search result
- `N` - Previous search result

#### Deleting Multiple Emails

##### Method 1: Tag and Delete
- `t` - Tag individual messages
- `T` - Tag by pattern (e.g., `~s spam` for spam subjects)
- `;d` - Delete all tagged messages

##### Method 2: Delete by Pattern
- `D` - Delete by pattern
- Examples:
  - `D~f annoying@example.com` - Delete all from specific address
  - `D~f @spam-domain.com` - Delete all from domain
  - `D~d >30d` - Delete all older than 30 days
  - `D~s "unsubscribe" ~d >7d` - Delete old unsubscribe emails

##### Quick Delete from Current Sender
- `D~f %f` - Delete all from current message's sender

##### Pattern Syntax Reference
- `~f pattern` - From contains pattern
- `~t pattern` - To contains pattern  
- `~s pattern` - Subject contains pattern
- `~b pattern` - Body contains pattern
- `~d >30d` - Older than 30 days (`d`=days, `w`=weeks, `m`=months)
- `~d <1w` - Less than 1 week old
- `~N` - New messages
- `~F` - Flagged messages
- `!` - NOT operator (e.g., `!~F` = not flagged)
- `|` - OR operator (e.g., `~f alice | ~f bob`)

##### Undo Deletions
- `u` - Undelete last deleted message
- `U` - Undelete by pattern
- Note: Deletions aren't permanent until you sync/exit

#### Troubleshooting

##### Fcc Failed Error (Sent Mail Not Saving)

If you see "Fcc failed. (r)etry, alternate (m)ailbox, or (s)kip?" when sending:

**Quick fix**: Press `s` to skip (your email was sent successfully)

**Permanent fixes**:

1. **Run the folder fix script**:
   ```bash
   ~/.config/mutt/scripts/fix-folders.sh
   ```

2. **For Gmail users**: Gmail auto-saves sent mail, so you can disable local copy:
   ```muttrc
   # In your account file, add:
   unset record
   ```

##### Gmail "Less secure apps" Error

Gmail requires App Passwords for security:

1. Enable 2-factor authentication on your Google account
2. Generate an App Password at https://myaccount.google.com/apppasswords
3. Use the App Password instead of your regular password
4. Update password: `pass edit mutt/youremail@gmail.com`

##### Images Not Displaying

Check w3m installation:

```bash
# Test image display
w3m -o display_image=1 https://example.com/image.jpg
```

#### Recommended Plugins

##### notmuch - Fast Search and Tagging
Powerful indexed search across all mail with tag-based organization:

```bash
# Install
yay -S notmuch

# Initialize
notmuch setup
notmuch new
```

##### lbdb - Little Brother Database
Auto-collects email addresses from your correspondence:

```bash
# Install
yay -S lbdb

# Add to muttrc
set query_command = "lbdbq '%s' 2>/dev/null"
```

##### mutt-ics - Calendar Integration
View and respond to calendar invites (already configured with calcurse integration).

#### Useful Macros

Add these to your `~/.config/mutt/muttrc`:

```muttrc
# Quick delete all from sender
macro index,pager ,d "<delete-pattern>~f %f<enter>" "Delete all from sender"

# Delete old emails (>30 days)
macro index ,o "<delete-pattern>~d >30d<enter>" "Delete old messages"

# Quick spam cleanup
macro index ,s "<tag-pattern>~s spam<enter><tag-prefix><delete-message>" "Delete spam"

# Archive (move to Archive folder)
macro index,pager ,a "<save-message>=Archive<enter>" "Archive message"

# Mark all as read
macro index ,r "<tag-pattern>~N<enter><tag-prefix><clear-flag>N<untag-pattern>.<enter>" "Mark all as read"

# Quick folder jumps
macro index gi "<change-folder>=INBOX<enter>" "Go to inbox"
macro index gs "<change-folder>=[Gmail]/Sent Mail<enter>" "Go to sent"
macro index gd "<change-folder>=[Gmail]/Drafts<enter>" "Go to drafts"
macro index gt "<change-folder>=[Gmail]/Trash<enter>" "Go to trash"
```

### Calcurse Calendar

Minimal, purposeful, and beautiful calendar and todo management with desktop notifications and email integration.

#### Features

- **BONSAI color theme** matching system aesthetic
- **Vim-like keybindings** for efficient navigation
- **Desktop notifications** via notify-send and swaync
- **Email integration** with mutt for calendar invites
- **CalDAV sync** support for Google Calendar and other services
- **Todo management** with priority levels
- **Daily agenda** summaries
- **Systemd integration** for automatic notifications

#### Quick Start

##### Launch Calcurse

Press `Super+C` in Hyprland to open calcurse, or run from terminal:

```bash
calcurse
```

#### Key Bindings

##### Navigation (Vim-like)
- `h/l` - Navigate days (left/right)
- `j/k` - Navigate weeks (down/up) 
- `b/w` - Navigate months (previous/next)
- `[/]` - Navigate years (previous/next)
- `Tab` - Switch between calendar, appointments, and todo panels
- `t` - Jump to today
- `g` - Go to specific date
- `C-d` - Scroll down half page
- `C-u` - Scroll up half page

##### Adding Items
- `a` - Add appointment (in calendar view)
- `T` - Add todo (in todo view)
- `e` - Edit selected item
- `d` - Delete selected item
- `c` - Copy item
- `p` - Paste item
- `n` - Add/edit note for item
- `!` - Flag/mark important
- `>` - View note

##### System Commands
- `s` - Save
- `R` - Reload data
- `C-l` - Refresh display
- `i` - Import data
- `x` - Export data
- `q` - Quit
- `?` - Help
- `C` - Configuration menu

##### Priority Management (Todo items)
- `+` - Raise priority
- `-` - Lower priority

#### Desktop Notifications

##### Automatic Setup

The notification daemon starts automatically with Hyprland. It provides:

- **15-minute warnings** before appointments
- **5-minute alerts** before appointments  
- **Daily agenda** at 8:00 AM
- **Todo deadline** reminders
- **Critical alerts** for imminent events

##### Manual Control

```bash
# Start notification daemon
systemctl --user start calcurse-notify.service

# Enable auto-start on boot
systemctl --user enable calcurse-notify.service

# Check status
systemctl --user status calcurse-notify.service

# View logs
journalctl --user -u calcurse-notify.service -f
```

##### Test Notifications

```bash
# Send test notification
notify-send -u normal "📅 Test Event" "This is a test notification"

# View today's agenda
~/.config/calcurse/scripts/daily-agenda.sh

# Send agenda as notification
~/.config/calcurse/scripts/daily-agenda.sh notify
```

#### Email Integration (Mutt)

##### Importing Calendar Invites

When you receive a calendar invite (.ics file) in mutt:

1. Open the email with the invite
2. Press `v` to view attachments
3. Select the .ics attachment
4. Press `C` to import to calcurse

Or use the keyboard shortcut from any mutt view:
- `Ctrl+C` - Open calcurse directly from mutt

##### Manual Import

```bash
# Import an ICS file
~/.config/calcurse/scripts/import-ics.sh calendar-invite.ics
```

#### CalDAV Synchronization

##### Google Calendar Setup

1. **Copy the config template:**
```bash
cp ~/.config/calcurse/caldav/config.sample ~/.config/calcurse/caldav/config
```

2. **Get Google credentials:**
   - Go to [Google Developer Console](https://console.developers.google.com/)
   - Create new project or select existing
   - Enable "Google Calendar API" and "CalDAV API"
   - Create OAuth 2.0 credentials (Desktop application)
   - Copy Client ID and Client Secret

3. **Edit config file:**
```bash
nano ~/.config/calcurse/caldav/config
```

Update these fields:
- `Path = /caldav/v2/YOUR_EMAIL@gmail.com/events/`
- `ClientID = YOUR_CLIENT_ID.apps.googleusercontent.com`
- `ClientSecret = YOUR_CLIENT_SECRET`
- `DryRun = No` (when ready to sync)

4. **Initialize sync:**
```bash
# First time - keep remote calendar
calcurse-caldav --init keep-remote

# Or keep local calendar
calcurse-caldav --init keep-local
```

5. **Regular sync:**
```bash
calcurse-caldav
```

##### Automated Sync

Add to crontab for automatic sync:
```bash
# Sync every 30 minutes
*/30 * * * * /usr/bin/calcurse-caldav 2>&1 | logger -t calcurse-caldav
```

Or create systemd timer:
```bash
# Enable timer
systemctl --user enable --now calcurse-caldav.timer
```

#### Todo Management

##### Priority Levels

Todos support priority levels 1-9:
- **1-3**: High priority (shown in red)
- **4-6**: Medium priority (shown in yellow)
- **7-9**: Low priority (shown in normal color)

##### Todo Operations

- `+` - Increase priority
- `-` - Decrease priority
- `x` - Mark as completed
- `>` - View note
- `n` - Edit note

#### Troubleshooting

##### Notifications Not Working

1. Check if notification daemon is running:
```bash
systemctl --user status calcurse-notify.service
```

2. Test notify-send:
```bash
notify-send "Test" "Testing notifications"
```

3. Check swaync is running:
```bash
pgrep swaync
```

##### CalDAV Sync Issues

1. Test with dry run:
```bash
# Edit config and set DryRun = Yes
calcurse-caldav
```

2. Check verbose output:
```bash
# Set Verbose = Yes in config
calcurse-caldav
```

3. Verify OAuth token:
```bash
ls -la ~/.config/calcurse/caldav/oauth_token
```

##### Import Issues

1. Verify ICS file format:
```bash
head calendar-invite.ics
# Should start with BEGIN:VCALENDAR
```

2. Manual import with calcurse:
```bash
calcurse -i calendar-invite.ics
```

#### Tips & Tricks

1. **Quick appointment**: Press `a` and type time directly (e.g., "14:30 Meeting")
2. **Recurring events**: Use repetition syntax when adding (e.g., "{daily}", "{weekly}")
3. **Quick todo**: Press `T` and add priority with `[1]` prefix
4. **Batch operations**: Use `@` to cut multiple items
5. **Export calendar**: Press `o` to export to ICS format
6. **Import multiple**: `calcurse -i *.ics` to import all ICS files

#### Integration with Other Tools

##### Waybar Module

Add to waybar config for calendar display:
```json
"custom/calcurse": {
    "exec": "calcurse --next | head -1",
    "interval": 300,
    "format": "📅 {}",
    "on-click": "kitty -e calcurse"
}
```

##### Rofi Integration

Create a rofi menu for quick actions:
```bash
#!/bin/bash
# ~/.config/rofi/scripts/calcurse-menu.sh
options="📅 Open Calcurse\n➕ Add Appointment\n✅ Add Todo\n📊 Show Agenda"
chosen=$(echo -e "$options" | rofi -dmenu -p "Calendar")

case "$chosen" in
    "📅 Open Calcurse") kitty -e calcurse ;;
    "➕ Add Appointment") kitty -e calcurse -a ;;
    "✅ Add Todo") kitty -e calcurse -t ;;
    "📊 Show Agenda") ~/.config/calcurse/scripts/daily-agenda.sh | rofi -dmenu ;;
esac
```

## Timeshift System Recovery

Timeshift creates system snapshots before updates. If an update breaks your system (e.g., NVIDIA driver incompatibility with new kernel), you can restore to a working state.

### Scenario 1: System Still Boots

If you can still boot (even with graphics issues):

```sh
# GUI method
sudo timeshift-gtk

# CLI method - list available snapshots
sudo timeshift --list

# CLI method - restore most recent snapshot
sudo timeshift --restore

# CLI method - restore specific snapshot
sudo timeshift --restore --snapshot '2024-01-15_10-30-45'
```

After restore → reboot.

### Scenario 2: System Won't Boot

If kernel/driver update completely breaks boot:

**Step 1:** Boot from Arch Live USB

**Step 2:** Mount your system

```sh
# Find your partitions
lsblk

# Mount root partition (replace sdXn with your actual partition)
sudo mount /dev/sdXn /mnt

# If you have a separate home partition
sudo mount /dev/sdYn /mnt/home
```

**Step 3:** Install and run Timeshift

```sh
# Install timeshift in live environment
sudo pacman -Sy timeshift

# Restore to mounted system
sudo timeshift --restore --target /mnt
```

**Step 4:** Reboot into restored system

```sh
sudo umount -R /mnt
sudo reboot
```

### Emergency Reference Card

Save this somewhere accessible (phone, notes app):

```
═══════════════════════════════════════════
TIMESHIFT EMERGENCY RESTORE
═══════════════════════════════════════════
1. Boot Arch Live USB
2. lsblk                              # find partitions
3. sudo mount /dev/sdXn /mnt          # mount root
4. sudo pacman -Sy timeshift
5. sudo timeshift --restore --target /mnt
6. sudo reboot
═══════════════════════════════════════════
```

### Useful Commands

```sh
# Create manual snapshot before risky operations
yasnap

# Safe update (auto-creates snapshot first)
yasu

# View recent package changes (after problems)
yahist

# Downgrade specific packages
yadown linux nvidia
```

## Python

```sh
python -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install pip-upgrade-tool pipreqs pynvim ruff
pip-upgrade --clear
pip-upgrade --yes
pipreqs --mode gt --force
```

## Usefull commands

```sh
systemctl list-units --type=service --state=running
sudo systemctl enable --now nordvpnd
sudo usermod -aG nordvpn zwelch
sudo lsof -ti:8000 | xargs kill -9
```