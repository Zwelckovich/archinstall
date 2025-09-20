#!/usr/bin/env bash
set -euo pipefail

script="install_bonsai.sh"

# Ensure user copy step uses arch-chroot for ownership adjustments
if ! grep -q 'arch-chroot /mnt chown -R "\$userstr:\$userstr" "/home/\$userstr/archinstall"' "$script"; then
  echo "Expected arch-chroot chown invocation not found in user copy step" >&2
  exit 1
fi

# Ensure there is no lingering non-chroot chown on /mnt/home path
if grep -q 'chown -R "\$userstr:\$userstr" "/mnt/home/\$userstr/archinstall"' "$script"; then
  echo "Found legacy chown outside chroot referencing /mnt/home" >&2
  exit 1
fi

echo "post_install_copy_test: chown invocation validated"
