#!/bin/bash
# Title: Batch Install VS Code Extensions
# Description: Reads extension IDs from code_extensions.txt and installs them using the VS Code CLI.

EXTENSION_FILE="code_extensions.txt"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 1. Check if extensions file exists in the current folder
if [[ ! -f "$EXTENSION_FILE" ]]; then
    echo -e "${RED}Error: Could not find '$EXTENSION_FILE' in the current directory.${NC}"
    echo "Please create the file or move this script to the correct folder."
    exit 1
fi

# 2. Check if VS Code CLI is available
if ! command -v code &> /dev/null; then
    echo -e "${RED}Error: The 'code' command is not found.${NC}"
    echo "Please ensure VS Code is installed and added to your PATH."
    exit 1
fi

echo -e "${CYAN}Starting installation from $EXTENSION_FILE...${NC}"

# 3. The Main Loop
while IFS= read -r ext || [[ -n "$ext" ]]; do
    # Clean whitespace and ignore empty lines
    ext=$(echo "$ext" | xargs)

    if [[ -n "$ext" ]]; then
        echo -e "${GREEN}Installing extension: $ext${NC}"
        code --install-extension "$ext"
    fi
done < "$EXTENSION_FILE"

echo -e "${CYAN}--------------------------------${NC}"
echo -e "${CYAN}All installation commands processed.${NC}"