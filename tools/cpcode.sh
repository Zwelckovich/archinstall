#!/bin/bash
# Description: Recursively finds files in a given directory with one or more provided file extensions,
# collects their contents with a header (the relative file path) and a separator,
# and copies the aggregated output to the clipboard using wl-copy (from wl-clipboard).
#
# Usage: ./script.sh /path/to/directory ext1 [ext2 ext3 ...]
# Example: ./script.sh /home/user/projects c js

# Check if wl-copy is available (required for Wayland)
if ! command -v wl-copy &>/dev/null; then
  echo "Error: wl-copy not found. Please install wl-clipboard." >&2
  exit 1
fi

# Ensure at least two arguments: directory and one file extension
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <directory> <extension1> [extension2 ...]" >&2
  exit 1
fi

# Get the directory and shift it from the arguments list
TARGET_DIR="$1"
shift

# Check if the provided directory exists and is indeed a directory
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory '$TARGET_DIR' does not exist." >&2
  exit 1
fi

# Build an array of file extensions (extensions provided without leading dot)
extensions=("$@")

# Build the 'find' command's expression by iterating over the extensions
find_args=()
for ext in "${extensions[@]}"; do
  find_args+=(-iname "*.${ext}" -o)
done
# Remove the trailing -o from the array
unset 'find_args[${#find_args[@]}-1]'

# Find files recursively in TARGET_DIR matching any of the given extensions,
# ignoring any .venv directories, and sort them by relative path.
files=$(find "$TARGET_DIR" -type d -name ".venv" -prune -o -type f \( "${find_args[@]}" \) -print 2>/dev/null | sort)

# If no files are found, show a reasoning error message and exit
if [ -z "$files" ]; then
  echo "Error: No files with extensions (${extensions[*]}) found in directory '$TARGET_DIR'." >&2
  exit 1
fi

# Initialize output variable to accumulate file content with headers
output=""

# Process each found file
while IFS= read -r file; do
  # Compute the relative path from the target directory
  relative_path=$(realpath --relative-to="$TARGET_DIR" "$file")
  # If the file is located in a subdirectory, prepend a slash to the relative path header;
  # files in the base directory are shown as-is.
  if [[ "$relative_path" == */* ]]; then
    header="/$relative_path"
  else
    header="$relative_path"
  fi
  # Append the header, a separator, and the file's content followed by an empty line
  output+="$header"$'\n'
  output+="------------------------------"$'\n'
  output+="$(cat "$file")"$'\n\n'
done <<<"$files"

# Copy the aggregated output to the clipboard using wl-copy
echo "$output" | wl-copy

echo "Content copied to clipboard."
