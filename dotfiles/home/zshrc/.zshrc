# hyfetch
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Path to bin
export PATH="$HOME/.local/bin:$PATH"

ZSH_THEME="powerlevel10k/powerlevel10k"
source ~/archinstall/catppuccin-zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode gh uv yarn)
source $ZSH/oh-my-zsh.sh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
zvm_after_init() {
  # Bind fzf's fuzzy completion
  bindkey '^I' fzf-completion
  bindkey '^[[Z' fzf-completion  # For shift-tab
}
# Only changing the escape key to `jk` in insert mode, we still
# keep using the default keybindings `^[` in other modes
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

alias reload-zsh="source ~/.zshrc"
alias edit-zsh="nvim ~/.zshrc"

# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ---- FZF -----

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/archinstall/fzf-git/fzf-git.sh

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# --- NPM ---
# 1. Initialize NVM (Specific to Arch Linux package)
if [ -s "/usr/share/nvm/init-nvm.sh" ]; then
    source /usr/share/nvm/init-nvm.sh
fi

# 2. Set the working directory for NVM (usually ~/.nvm)
export NVM_DIR="$HOME/.nvm"

# 3. Auto-install Node if none is present
if [ "$(nvm current)" = "none" ]; then
    echo "NVM: No Node.js version detected. Installing latest LTS..."
    nvm install --lts
    nvm alias default 'lts/*'
    nvm use default
fi

# ----- NeoVim -----
export EDITOR="nvim"

# ----- Bat (better cat) -----

export BAT_THEME="Catppuccin Mocha"
alias cat="bat"

# ---- Eza (better ls) -----

alias la="eza -al --icons=always --color=always --group-directories-first"
alias ls="eza -l --icons=always --color=always --group-directories-first"

# ---- TheFuck -----

# thefuck alias

eval $(thefuck --alias)
eval $(thefuck --alias fk)

# ---- Zoxide (better cd) ----

eval "$(zoxide init zsh)"
alias cd="z"

# ---- LazyGit ----

alias lg="lazygit"

# ---- YAY ----

# Basic operations
alias yain="yay -S --noconfirm"        # Install package
alias yarem="yay -Rns --noconfirm"     # Remove with deps
alias yareps="yay -Ss"                 # Search repos
alias yalst="yay -Qe"                  # List explicitly installed
alias yainfo="yay -Qi"                 # Package info

# System maintenance
alias yamir="yay -Syy"                 # Refresh mirrors
alias yaclr="sudo rm -rf /var/cache/pacman/pkg/download-* 2>/dev/null; yay -Scc"  # Clear cache (including stray downloads)
alias yakey="sudo pacman -S archlinux-keyring"
alias yaref="sudo reflector --verbose --country Germany --age 12 --protocol https,http --sort rate --save /etc/pacman.d/mirrorlist"

# Disk usage
alias yabig="expac -H M '%m\t%n' | sort -h | tail -20"

# Reinstall yay (fixed typo)
alias yareinstall="sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si"

# Clean orphans (interactive)
yaclean() {
  local orphans=$(yay -Qtdq 2>/dev/null)
  if [[ -n "$orphans" ]]; then
    echo "Orphaned packages:"
    echo "$orphans"
    echo ""
    read -q "?Remove these packages? [y/N] " && echo && yay -Rns $(echo $orphans)
  else
    echo "No orphaned packages found."
  fi
}

# ---- TIMESHIFT (System Snapshots) ----

alias yasnap="sudo timeshift --create --comments 'Pre-update $(date +%Y-%m-%d_%H-%M)'"
alias yasu='yasnap && yay -Syu --noconfirm --mflags "--nocheck"'

# Recovery helpers
alias yadown="sudo downgrade"          # Downgrade packages
alias yahist="tail -50 /var/log/pacman.log | grep -E 'upgraded|installed|removed'"

# ---- TLDR ----

alias help="tldr"

# ---- CD Alias ----

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# --- Python Aliases ---

alias py="python"
alias pyact="source .venv/bin/activate && which python"
alias pydeact="deactivate && which python"
alias pyvenv="python -m venv .venv && cp ~/archinstall/tools/requirements.txt ./"
alias pycheck="uv run ruff check --fix && uv run ruff format && uv run pyright"

# --- Tree Aliases ---

alias tree="tre"


# --- Citrix Aliases ---
alias citrix="/opt/Citrix/ICAClient/wfica"


# --- NCDU Aliases ---
alias ds="ncdu --color dark"

# --- Yazi Aliases ---
alias ee="yazi"

# --- MPV Aliases ---
alias mpv_anime="mpv --include=~/archinstall/tools/mpv/anime-quality.conf"

# --- XDG-OPEN Aliases ---
alias -s jpg=feh
alias -s jpeg=feh
alias -s png=feh
alias -s pdf=zathura

# --- Programming Environment Update ---
alias codeup="yamir && yain uv yarn biome visual-studio-code-bin && claude update && code --update-extensions && npm install -g @google/gemini-cli"

# --- LibreVNA GUI ---
alias librevna="/usr/bin/LibreVNA-GUI > /dev/null 2>&1 &"
