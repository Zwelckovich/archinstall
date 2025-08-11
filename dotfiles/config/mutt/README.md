# 🌱 BONSAI Mutt Configuration

Minimal, purposeful, and beautiful email client configuration with modern HTML/image support.

## Features

- **BONSAI color theme** matching system aesthetic
- **HTML email rendering** with inline images using w3m
- **Multiple account support** (Gmail, T-Online, Outlook, Yahoo, custom IMAP)
- **Vim-like keybindings** for efficient navigation
- **Secure password storage** using `pass`
- **Smart MIME handling** for attachments, images, PDFs
- **Sidebar navigation** for folder overview
- **URL extraction** with urlscan

## Quick Start

### Prerequisites

The following packages will be installed by `install_bonsai.sh`:
- `neomutt` - Modern mutt email client with enhanced features
- `w3m` - HTML rendering with image support
- `lynx` - Alternative HTML converter
- `urlscan` - URL extraction from emails
- `isync` (mbsync) - IMAP synchronization
- `msmtp` - SMTP client for sending
- `pass` - Password manager
- `abook` - Address book

### Installation

After running the BONSAI installer, mutt will be configured automatically. To set up your first account:

```bash
~/.config/mutt/scripts/add-account.sh
```

## Adding Email Accounts

### Method 1: Interactive Setup (Recommended)

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

### Method 2: Manual Configuration

#### Gmail Account

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

3. Create `~/.config/mutt/accounts/gmail`:
   ```muttrc
   set realname = "Your Name"
   set from = "youremail@gmail.com"
   set imap_user = "youremail@gmail.com"
   set imap_pass = "`pass mutt/youremail@gmail.com`"
   set smtp_url = "smtps://youremail@gmail.com@smtp.gmail.com:465"
   set smtp_pass = "`pass mutt/youremail@gmail.com`"
   set folder = "imaps://imap.gmail.com:993"
   set spoolfile = "+INBOX"
   set postponed = "+[Gmail]/Drafts"
   set trash = "+[Gmail]/Trash"
   set record = "+[Gmail]/Sent Mail"
   ```

4. Add to `~/.config/mutt/muttrc`:
   ```muttrc
   source ~/.config/mutt/accounts/gmail
   folder-hook gmail/* source ~/.config/mutt/accounts/gmail
   ```

#### T-Online Account

1. Store password:
   ```bash
   pass insert mutt/youremail@t-online.de
   ```

2. Create `~/.config/mutt/accounts/t-online`:
   ```muttrc
   set realname = "Your Name"
   set from = "youremail@t-online.de"
   set imap_user = "youremail@t-online.de"
   set imap_pass = "`pass mutt/youremail@t-online.de`"
   set smtp_url = "smtps://youremail@t-online.de@securesmtp.t-online.de:465"
   set smtp_pass = "`pass mutt/youremail@t-online.de`"
   set folder = "imaps://secureimap.t-online.de:993"
   set spoolfile = "+INBOX"
   set postponed = "+Entwürfe"
   set trash = "+Papierkorb"
   set record = "+Gesendet"
   ```

3. Add to `~/.config/mutt/muttrc`:
   ```muttrc
   source ~/.config/mutt/accounts/t-online
   folder-hook t-online/* source ~/.config/mutt/accounts/t-online
   ```


## Key Bindings

### Navigation (Vim-like)
- `j/k` - Move down/up in message list
- `gg/G` - Go to first/last message
- `Ctrl-d/u` - Page down/up
- `Enter` - Open message
- `q` - Go back/quit

### Sidebar
- `Ctrl-n` - Next folder in sidebar
- `Ctrl-p` - Previous folder in sidebar
- `Ctrl-o` - Open selected folder

### Message Actions
- `r` - Reply to sender
- `R` - Reply to all
- `f` - Forward message
- `d` - Delete message
- `u` - Undelete message
- `s` - Save message to folder
- `c` - Change to different folder
- `m` - Compose new message
- `a` - Add sender to address book

### HTML & Attachments
- `v` - View attachments list
- **In attachment view:**
  - `V` - Open HTML/attachment in browser (Vivaldi)
  - `I` - Extract all images from email
  - `Enter` - View attachment in mutt
  - `s` - Save attachment to disk
  - `?` or `h` - Show attachment help
  - `q` - Exit attachment view
- `Ctrl-b` - Extract and browse URLs from message (in message view)

### Searching
- `/` - Search in current folder
- `n` - Next search result
- `N` - Previous search result

### Tagging
- `t` - Tag/untag message
- `;` - Apply next command to tagged messages

## HTML Email Handling

HTML emails are automatically converted to readable text using w3m. The conversion preserves:
- Links (shown in brackets)
- Basic formatting (bold, italic)
- Lists and tables
- Image alt text

### Viewing Complex HTML

For emails with complex layouts that don't render well in text:

1. Press `v` to view attachments
2. Select the HTML attachment (usually `text/html`)
3. Press `V` to open in your browser with BONSAI styling

### Inline Images

Images in HTML emails can be viewed in several ways:

1. **Automatic**: w3m shows image placeholders with alt text
2. **Preview in terminal**: Select image attachment and press Enter (uses chafa)
3. **Full view**: Select image and press Enter twice (opens in feh)
4. **Extract all**: Press `I` on any attachment to extract and view all images

## Managing Multiple Accounts

### Switching Between Accounts

1. Press `c` to change folder
2. Use `Tab` for folder completion
3. Navigate to the other account's INBOX

### Account-Specific Settings

Each account configuration can have custom settings:

```muttrc
# In ~/.config/mutt/accounts/work
set signature = ~/.config/mutt/signatures/work.sig
set postponed = "+Drafts"
set from = "work@company.com"

# In ~/.config/mutt/accounts/personal  
set signature = ~/.config/mutt/signatures/personal.sig
set postponed = "+[Gmail]/Drafts"
set from = "personal@gmail.com"
```

## Troubleshooting

### Gmail "Less secure apps" Error

Gmail requires App Passwords for security:

1. Enable 2-factor authentication on your Google account
2. Generate an App Password at https://myaccount.google.com/apppasswords
3. Use the App Password instead of your regular password
4. Update password: `pass edit mutt/youremail@gmail.com`

### T-Online Connection Issues

Ensure you're using the correct servers:
- IMAP: `secureimap.t-online.de:993` (SSL/TLS)
- SMTP: `securesmtp.t-online.de:465` (SSL/TLS)

### Images Not Displaying

Check w3m installation and configuration:

```bash
# Install w3m with image support
yay -S w3m

# Test image display
w3m -o display_image=1 https://example.com/image.jpg
```

If images still don't work:
- Try using `chafa` for terminal image preview
- Use the extract images script (`I` key)

### URL Extraction Not Working

Install urlscan:

```bash
yay -S urlscan
```

### Password Issues

If `pass` is not initialized:

```bash
# Generate GPG key if needed
gpg --gen-key

# Initialize pass with your GPG key
pass init your-gpg-key-id
```

### Folder Names in Different Languages

For non-English email providers, folder names might be different:

- German (T-Online): Entwürfe (Drafts), Gesendet (Sent), Papierkorb (Trash)
- French: Brouillons (Drafts), Envoyés (Sent), Corbeille (Trash)
- Spanish: Borradores (Drafts), Enviados (Sent), Papelera (Trash)

Update your account configuration accordingly.

## Advanced Configuration

### Custom Keybindings

Add to `~/.config/mutt/muttrc`:

```muttrc
# Archive messages with 'e'
macro index,pager e "<save-message>+Archive<enter>" "Archive message"

# Mark all as read with 'A'
macro index A "<tag-pattern>~N<enter><tag-prefix><clear-flag>N<untag-pattern>.<enter>" "Mark all as read"
```

### Signature Management

Create different signatures for different accounts:

```bash
# Create signature files
echo -e "--\nBest regards,\nYour Name" > ~/.config/mutt/signatures/personal.sig
echo -e "--\nSincerely,\nYour Name\nJob Title" > ~/.config/mutt/signatures/work.sig

# Set in account config
set signature = ~/.config/mutt/signatures/personal.sig
```

### Address Book

Use `abook` for contact management:

```muttrc
# Add to muttrc
set query_command = "abook --mutt-query '%s'"
macro index,pager a "<pipe-message>abook --add-email-quiet<return>" "Add to address book"
```

### Encrypted Email (GPG)

Enable GPG support:

```muttrc
# Add to muttrc
source /usr/share/doc/mutt/samples/gpg.rc
set pgp_use_gpg_agent = yes
set pgp_sign_as = YOUR_GPG_KEY_ID
set pgp_timeout = 3600
set crypt_autosign = yes
set crypt_replyencrypt = yes
```

## BONSAI Philosophy

This mutt configuration follows BONSAI principles:

- **Minimal**: Only essential features configured, no bloat
- **Purposeful**: Every setting serves a clear purpose
- **Beautiful**: BONSAI color theme for visual harmony

The configuration provides a powerful, keyboard-driven email experience that matches the efficiency of neovim while handling modern email requirements.

## Tips & Tricks

1. **Quick folder switching**: Press `c` then `?` to see all folders
2. **Batch operations**: Tag messages with `t`, then apply commands with `;`
3. **Save attachments**: Press `s` on an attachment to save to disk
4. **Thread navigation**: Use `Ctrl-n/p` to jump between threads
5. **Limit view**: Press `l` to limit view to matching messages
6. **Check new mail**: Press `$` to sync current folder

## Support

For issues or questions:
- Check the [NeoMutt documentation](https://neomutt.org/guide/)
- Review your account settings in `~/.config/mutt/accounts/`
- Verify passwords with `pass show mutt/youremail`
- Check mutt's error messages with `:` key