# Repository Guidelines

This guide orients contributors to the Arch + Hyprland installer project so you can assist quickly
and safely.

## Project Structure & Module Organization
Primary entry points live in `install.sh` and `install_bonsai.sh`; both stream output to
`install.log` or `install_bonsai.log` for troubleshooting. Dotfiles are staged under
`dotfiles/` with `config/` and `home/` subtrees intended for GNU Stow (`stow -t ~/ -d dotfiles/config waybar`).
Sensitive artifacts sit in `secrets/` and are managed with git-crypt. Supporting assets include
`wallpaper/`, the vendored `fzf-git/` helper, and the `catppuccin-zsh-syntax-highlighting/`
plugin. Reference docs live in `README.md` and Hyprland-specific notes in `BONSAI.md`.

## Build, Test, and Development Commands
Run `shellcheck install.sh install_bonsai.sh` to lint Bash usage, followed by
`shfmt -i 2 -s -w .` to enforce formatting. Validate syntax quickly with
`bash -n install.sh install_bonsai.sh`. When you must execute an installer, prefer a disposable VM:
`qemu-system-x86_64` or VirtualBox snapshots prevent data loss. Never run the scripts on a live system.

## Coding Style & Naming Conventions
Author portable Bash and document any required bashisms. Use two-space indentation, avoid tabs,
and keep lines under ~100 characters. Functions adopt `snake_case` (e.g., `restore_dotfiles`),
constants use `UPPER_SNAKE` (`INSTLOG`, `CNT`), and arrays stay in `snake_case`. Status messages
should reuse the existing `CNT`/`COK`/`CER` prefixes for a consistent UX.

## Testing Guidelines
Always perform static checks (`bash -n`, `shellcheck`, `shfmt`) before review. Functional testing
belongs in an isolated VM to avoid destructive partitioning and package operations; capture the
resulting `install*.log` plus console output. Where possible, exercise individual functions to
reduce VM churn—for example, source the script and call `restore_dotfiles` with faked inputs.

## Commit & Pull Request Guidelines
Commits follow the Conventional Commits format (`feat:`, `fix:`, `docs:`, `refactor:`, `chore:`)
with ≤72-character subjects. Pull requests should clarify purpose, enumerate disk-related risks,
link issues, and show evidence of testing (VM details, logs, relevant diffs). Document any
changes that impact secrets or AUR dependencies.

## Security & Configuration Tips
Unlock encrypted material via `git-crypt unlock ../git-crypt-key`; never stage plaintext secrets.
When adding packages, highlight new AUR dependencies and validate their trustworthiness. Treat
any credential, token, or key material as out-of-scope for version control.
