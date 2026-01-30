#!/bin/bash
# Title: Batch Install VS Code Extensions
# Description: Reads extension IDs from code_extensions.txt and installs them using the VS Code CLI.
# Usage: ./install_extensions.sh [--clean|-c]
#   --clean, -c: Uninstall all existing extensions before installing new ones

EXTENSION_FILE="code_extensions.txt"
CLEAN_INSTALL=false

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --clean|-c)
            CLEAN_INSTALL=true
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Usage: $0 [--clean|-c]"
            exit 1
            ;;
    esac
done

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

# 3. If --clean flag is set, uninstall all existing extensions first
if [[ "$CLEAN_INSTALL" == true ]]; then
    echo -e "${YELLOW}Clean install requested - removing all existing extensions...${NC}"
    EXISTING_EXTENSIONS=$(code --list-extensions 2>/dev/null)

    if [[ -n "$EXISTING_EXTENSIONS" ]]; then
        TOTAL_TO_REMOVE=$(echo "$EXISTING_EXTENSIONS" | wc -l)
        echo -e "${YELLOW}Found $TOTAL_TO_REMOVE extensions to remove.${NC}"

        while IFS= read -r ext || [[ -n "$ext" ]]; do
            ext=$(echo "$ext" | xargs)
            if [[ -n "$ext" ]]; then
                echo -e "${RED}Uninstalling: $ext${NC}"
                code --uninstall-extension "$ext"
            fi
        done <<< "$EXISTING_EXTENSIONS"

        echo -e "${YELLOW}All existing extensions removed.${NC}"
        echo -e "${CYAN}--------------------------------${NC}"
    else
        echo -e "${YELLOW}No existing extensions found.${NC}"
    fi
fi

echo -e "${CYAN}Starting installation from $EXTENSION_FILE...${NC}"

# 4. Get list of already installed extensions (prevents V8 crash on re-install)
echo -e "${CYAN}Checking installed extensions...${NC}"
INSTALLED_EXTENSIONS=$(code --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]')

# 5. The Main Loop
while IFS= read -r ext || [[ -n "$ext" ]]; do
    # Clean whitespace and ignore empty lines
    ext=$(echo "$ext" | xargs)

    if [[ -n "$ext" ]]; then
        # Check if extension is already installed (case-insensitive)
        ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
        if echo "$INSTALLED_EXTENSIONS" | grep -q "^${ext_lower}$"; then
            echo -e "${CYAN}Skipping (already installed): $ext${NC}"
            continue
        fi

        echo -e "${GREEN}Installing extension: $ext${NC}"
        code --install-extension "$ext"
    fi
done < "$EXTENSION_FILE"

echo -e "${CYAN}--------------------------------${NC}"
echo -e "${CYAN}All installation commands processed.${NC}"
