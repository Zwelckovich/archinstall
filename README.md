# Archinstall Catppuccin Style

## Install

```sh
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

| Example                                 | Description                                      |
|-----------------------------------------|--------------------------------------------------|
| CTRL-t                                  | Look for files and directories                   |
| CTRL-r                                  | Look through command history                     |
| Enter                                   | Select the item                                  |
| Ctrl-j or Ctrl-n or Down arrow          | Go down one result                               |
| Ctrl-k or Ctrl-p or Up arrow            | Go up one result                                 |
| Tab                                     | Mark a result                                    |
| Shift-Tab                               | Unmark a result                                  |
| cd **Tab                                | Open up fzf to find directory                    |
| export **Tab                            | Look for env variable to export                  |
| unset **Tab                             | Look for env variable to unset                   |
| unalias **Tab                           | Look for alias to unalias                        |
| ssh **Tab                               | Look for recently visited host names             |
| kill -9 **Tab                           | Look for process name to kill to get pid         |
| any command (like nvim or code) + **Tab | Look for files & directories to complete command |

### fzf-git

| Keybind | Description                         |
|---------|-------------------------------------|
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
|---------|--------------|
| CTRL-A  | Tmux Mod Key |
