#!/usr/bin/env bash
set -euo pipefail

script="install_bonsai.sh"

if ! grep -Fq 'arch-chroot /mnt sed -i "s/^[#[:space:]]*${variable}/${variable}/" /etc/locale.gen' "$script"; then
  echo "Expected resilient sed expression to un-comment en_US.UTF-8 not found" >&2
  exit 1
fi

if grep -Fq 'arch-chroot /mnt sed -i "s/^#\?$variable$/$variable/" /etc/locale.gen' "$script"; then
  echo "Found legacy sed pattern that fails to un-comment locale" >&2
  exit 1
fi

if ! grep -Fq 'if ! arch-chroot /mnt locale-gen; then' "$script"; then
  echo "Locale generation error handling block missing" >&2
  exit 1
fi

if ! grep -Fq "arch-chroot /mnt locale -a | grep -qi '^en_US\\.utf8$'" "$script"; then
  echo "Locale verification against locale -a missing" >&2
  exit 1
fi

echo "locale_configuration_test: locale handling hardened"
