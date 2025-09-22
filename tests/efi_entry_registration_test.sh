#!/usr/bin/env bash
set -euo pipefail

script="install_bonsai.sh"

contains() {
  local pattern="$1"
  local description="$2"
  if ! grep -qE "$pattern" "$script"; then
    echo "Missing expected pattern: $description" >&2
    exit 1
  fi
}

contains 'register_efi_entry\(\)' "EFI registration helper defined"
contains 'arch-chroot /mnt efibootmgr "\$\{create_args\[@\]\}"' "register_efi_entry attempts target environment"
contains 'if command -v efibootmgr >/dev/null 2>&1; then' "register_efi_entry checks host fallback"
contains 'efibootmgr "\$\{create_args\[@\]\}"' "register_efi_entry host fallback uses same arguments"
contains 'Manual fallback: efibootmgr --create --disk' "register_efi_entry logs manual command"

printf 'efi_entry_registration_test: helper structure verified\n'
