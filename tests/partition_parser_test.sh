#!/usr/bin/env bash
set -euo pipefail

parse_partition() {
  local part_path="$1"
  local boot_disk=""
  local boot_part=""

  if [[ "$part_path" =~ ^(/dev/nvme[0-9]+n[0-9]+)p([0-9]+)$ ]]; then
    boot_disk="${BASH_REMATCH[1]}"
    boot_part="${BASH_REMATCH[2]}"
  elif [[ "$part_path" =~ ^(/dev/mmcblk[0-9]+)p([0-9]+)$ ]]; then
    boot_disk="${BASH_REMATCH[1]}"
    boot_part="${BASH_REMATCH[2]}"
  elif [[ "$part_path" =~ ^(/dev/[a-zA-Z]+)([0-9]+)$ ]]; then
    boot_disk="${BASH_REMATCH[1]}"
    boot_part="${BASH_REMATCH[2]}"
  fi

  if [[ -z "$boot_disk" || -z "$boot_part" ]]; then
    return 1
  fi

  printf '%s %s\n' "$boot_disk" "$boot_part"
}

cases=(
  "/dev/nvme0n1p1:/dev/nvme0n1:1"
  "/dev/sda1:/dev/sda:1"
  "/dev/mmcblk0p2:/dev/mmcblk0:2"
  "/dev/vda3:/dev/vda:3"
)

for case in "${cases[@]}"; do
  IFS=':' read -r input expected_disk expected_part <<<"$case"
  output=$(parse_partition "$input")
  IFS=' ' read -r actual_disk actual_part <<<"$output"
  if [[ "$actual_disk" != "$expected_disk" || "$actual_part" != "$expected_part" ]]; then
    echo "Partition parsing failed for $input (expected $expected_disk/$expected_part, got $actual_disk/$actual_part)" >&2
    exit 1
  fi
done

# Ensure unsupported formats fail gracefully
if parse_partition "/dev/mapper/cryptroot"; then
  echo "Unexpected success when parsing mapper path" >&2
  exit 1
fi

echo "partition_parser_test: all cases passed"
