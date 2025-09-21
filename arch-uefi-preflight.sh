#!/usr/bin/env bash
set -euo pipefail

RED=$'\e[31m'; GRN=$'\e[32m'; YLW=$'\e[33m'; BLU=$'\e[34m'; NC=$'\e[0m'
ok(){ echo "${GRN}[OK]${NC} $*"; }
warn(){ echo "${YLW}[WARN]${NC} $*"; }
bad(){ echo "${RED}[FAIL]${NC} $*"; }

fail=0

# 0) UEFI mode & NVRAM writable
if [[ -d /sys/firmware/efi/efivars ]]; then
  ok "Booted in UEFI mode."
else
  bad "Not in UEFI mode (no /sys/firmware/efi/efivars)."
  fail=1
fi

if efibootmgr >/dev/null 2>&1; then
  ok "NVRAM appears writable (efibootmgr works)."
else
  bad "NVRAM not writable or efibootmgr unavailable."
  fail=1
fi

# 1) Secure Boot state (informational)
if command -v mokutil >/dev/null 2>&1; then
  sb=$(mokutil --sb-state 2>/dev/null || true)
  echo "${BLU}[INFO]${NC} $sb"
fi

# 2) Find ESP mount
ESP_MNT=""
for m in /boot /efi; do
  if mountpoint -q "$m"; then
    fstype=$(findmnt -no FSTYPE "$m")
    ptype=$(lsblk -no PARTTYPE "$(findmnt -no SOURCE "$m")" 2>/dev/null || true)
    if [[ "$fstype" == "vfat" || "$fstype" == "fat" || "$fstype" == "msdos" ]]; then
      if [[ "${ptype,,}" == "c12a7328-f81f-11d2-ba4b-00a0c93ec93b" ]]; then
        ESP_MNT="$m"
        ok "ESP mounted at $ESP_MNT (FAT32, correct GPT type)."
        break
      else
        warn "Partition at $m is FAT but not ESP type (GPT EF00)."
      fi
    fi
  fi
done

if [[ -z "${ESP_MNT}" ]]; then
  bad "No proper ESP mounted at /boot or /efi."
  fail=1
else
  # 3) Required files on ESP
  [[ -f "$ESP_MNT/EFI/systemd/systemd-bootx64.efi" ]] \
    && ok "systemd-boot present: $ESP_MNT/EFI/systemd/systemd-bootx64.efi" \
    || { bad "Missing systemd-bootx64.efi on ESP."; fail=1; }

  [[ -f "$ESP_MNT/EFI/BOOT/BOOTX64.EFI" ]] \
    && ok "Fallback BOOTX64.EFI present." \
    || warn "No fallback BOOTX64.EFI (recommended)."

  # 4) loader config
  if [[ -f "$ESP_MNT/loader/loader.conf" ]]; then
    ok "Found loader.conf"
    DEFAULT_ENTRY=$(sed -n 's/^[[:space:]]*default[[:space:]]\+//p' "$ESP_MNT/loader/loader.conf" | head -n1 || true)
    if [[ -n "${DEFAULT_ENTRY:-}" ]]; then
      [[ -f "$ESP_MNT/loader/entries/${DEFAULT_ENTRY}.conf" ]] \
        && ok "Default entry exists: ${DEFAULT_ENTRY}.conf" \
        || { bad "Default entry set to '$DEFAULT_ENTRY' but file is missing."; fail=1; }
    else
      warn "No 'default' set in loader.conf (systemd-boot will prompt)."
    fi
  else
    bad "Missing $ESP_MNT/loader/loader.conf"
    fail=1
  fi
fi

# 5) Validate entries
root_ok=1
for e in "$ESP_MNT"/loader/entries/*.conf; do
  [[ -e "$e" ]] || continue
  title=$(sed -n 's/^title[[:space:]]\+//p' "$e" | head -n1)
  linux_rel=$(sed -n 's/^linux[[:space:]]\+//p' "$e" | head -n1)
  initrd_rel=$(sed -n 's/^initrd[[:space:]]\+//p' "$e" | head -n1)
  options=$(sed -n 's/^options[[:space:]]\+//p' "$e" | tr -d '"' | head -n1)

  echo "— Entry: $(basename "$e") ${title:+($title)}"

  # Kernel/initrd files (relative to ESP mount)
  if [[ -n "$linux_rel" && -f "$ESP_MNT/$linux_rel" ]]; then
    ok "Kernel found: $linux_rel"
  else
    bad "Kernel missing: $linux_rel"
    root_ok=0
  fi
  if [[ -n "$initrd_rel" ]]; then
    missing=0
    for f in $initrd_rel; do
      [[ -f "$ESP_MNT/$f" ]] || missing=1
    done
    [[ $missing -eq 0 ]] && ok "Initrd(s) found: $initrd_rel" || { bad "Missing initrd(s): $initrd_rel"; root_ok=0; }
  fi

  # root= validation
  root_arg=$(sed -E 's/.*\broot=([^ ]+).*/\1/;t;d' <<<"$options" || true)
  if [[ -z "${root_arg:-}" ]]; then
    warn "No root= in options (OK if using UKI with builtin cmdline)."
  else
    case "$root_arg" in
      UUID=* )
        ruuid=${root_arg#UUID=}
        if blkid | grep -q " UUID=\"$ruuid\"" ; then
          ok "root=UUID matches an existing filesystem."
        else
          bad "root=UUID=$ruuid not found on any block device."
          root_ok=0
        fi
        ;;
      PARTUUID=* )
        rpuuid=${root_arg#PARTUUID=}
        if blkid | grep -q " PARTUUID=\"$rpuuid\"" ; then
          ok "root=PARTUUID matches a partition."
        else
          bad "root=PARTUUID=$rpuuid not found."
          root_ok=0
        fi
        ;;
      LABEL=* )
        rlabel=${root_arg#LABEL=}
        if blkid -o list | awk '{print $3}' | grep -qx "$rlabel"; then
          ok "root=LABEL matches a device."
        else
          bad "root=LABEL=$rlabel not found."
          root_ok=0
        fi
        ;;
      /dev/* )
        [[ -e "$root_arg" ]] && ok "root device exists: $root_arg" || { bad "root device not found: $root_arg"; root_ok=0; }
        ;;
      * )
        warn "Unrecognized root= format: $root_arg"
        ;;
    esac
  fi
done

[[ $root_ok -eq 1 ]] || fail=1

# 6) Cross-check efibootmgr target -> ESP partition + file path
if efibootmgr -v >/tmp/efi.out 2>/dev/null; then
  echo "— Checking NVRAM entries against ESP…"
  esp_src=$(findmnt -no SOURCE "$ESP_MNT")
  esp_partuuid=$(lsblk -no PARTUUID "$esp_src" 2>/dev/null || true)
  if [[ -n "$esp_partuuid" ]]; then
    if grep -qi "HD(.*,GPT,${esp_partuuid^^}" /tmp/efi.out; then
      ok "A boot entry points to the correct ESP (PARTUUID=$esp_partuuid)."
    else
      bad "No boot entry points to this ESP (PARTUUID=$esp_partuuid)."
      fail=1
    fi
  fi

  # Does the entry’s file exist?
  if grep -Eio 'File\\\([^)]+\)' /tmp/efi.out | sed 's/^File\\(//;s/)$//' | sort -u >/tmp/efi_files.txt; then
    found_match=0
    while IFS= read -r p; do
      localp="${p//\\//}"  # backslashes -> slashes
      if [[ -f "$ESP_MNT/$localp" ]]; then
        ok "NVRAM entry file exists on ESP: /$localp"
        found_match=1
        break
      fi
    done < /tmp/efi_files.txt
    [[ $found_match -eq 1 ]] || { bad "NVRAM entry path(s) don’t exist on the ESP."; fail=1; }
  fi
else
  bad "Couldn’t read efibootmgr -v output."
  fail=1
fi

# 7) Suggest fallback creation if missing
if [[ -n "${ESP_MNT:-}" && ! -f "$ESP_MNT/EFI/BOOT/BOOTX64.EFI" && -f "$ESP_MNT/EFI/systemd/systemd-bootx64.efi" ]]; then
  warn "Consider: cp -f \"$ESP_MNT/EFI/systemd/systemd-bootx64.efi\" \"$ESP_MNT/EFI/BOOT/BOOTX64.EFI\""
fi

echo
if [[ $fail -eq 0 ]]; then
  echo "${GRN}All checks passed. The UEFI → systemd-boot → kernel chain looks good.${NC}"
  exit 0
else
  echo "${RED}One or more checks failed. Review the [FAIL]/[WARN] lines above.${NC}"
  exit 1
fi
