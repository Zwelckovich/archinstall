#!/bin/bash
# Simple test script for mutt configuration

echo "Testing BONSAI Mutt Configuration..."

# Test 1: Check if configuration files exist
echo -n "Checking configuration files... "
if [ -f ~/.config/mutt/muttrc ] && [ -f ~/.config/mutt/colors-bonsai.muttrc ]; then
    echo "✓"
else
    echo "✗ Missing files"
    exit 1
fi

# Test 2: Check if scripts are executable
echo -n "Checking script permissions... "
if [ -x ~/.config/mutt/scripts/add-account.sh ]; then
    echo "✓"
else
    echo "✗ Scripts not executable"
    exit 1
fi

# Test 3: Verify mutt can parse the configuration
echo -n "Verifying mutt configuration syntax... "
if neomutt -n -F ~/.config/mutt/muttrc -e 'quit' 2>/dev/null; then
    echo "✓"
else
    echo "✗ Configuration error"
    exit 1
fi

echo "All tests passed!"