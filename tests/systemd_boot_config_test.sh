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

contains 'default  arch' "loader.conf default entry without .conf"
contains 'arch-fallback\.conf' "fallback boot entry configuration"
contains 'BONSAI Linux \(systemd-boot\)' "custom EFI label for systemd-boot"
contains 'bootctl install --esp-path=/boot --boot-path=/boot --make-entry=yes' "explicit bootctl install arguments"
contains 'efibootmgr --create --disk' "manual efibootmgr fallback logic"
contains 'cryptsetup luksOpen "\$PARTITION2" cryptroot' "consistent cryptroot mapper naming"
contains 'root=/dev/mapper/cryptroot' "kernel option references cryptroot mapper"

printf 'systemd_boot_config_test: all static configuration checks passed\n'
