#!/bin/bash
# Test which key configuration works better

echo "Testing calcurse key configurations..."
echo

# Backup current keys
cp ~/.config/calcurse/keys ~/.config/calcurse/keys.backup 2>/dev/null

# Test strict vim mode
echo "Testing strict vim mode (with C-u)..."
cp ~/.config/calcurse/keys.vim-strict ~/.config/calcurse/keys
calcurse --next 1 2>&1 | grep -i "error\|warning\|assigned"

if [ $? -eq 0 ]; then
    echo "❌ Strict vim mode has conflicts"
    echo "Using safe mode with PageUp instead of C-u"
    cp ~/.config/calcurse/keys.backup ~/.config/calcurse/keys
else
    echo "✅ Strict vim mode works! C-u is available"
    echo "You can now use C-u for scroll up"
fi

echo
echo "Current key bindings:"
echo "  h/l - Previous/next day"
echo "  j/k - Previous/next week" 
echo "  C-d - Scroll down"
if grep -q "generic-scroll-up.*C-u" ~/.config/calcurse/keys 2>/dev/null; then
    echo "  C-u - Scroll up (vim-like)"
else
    echo "  PageUp - Scroll up (C-u conflicts with calcurse)"
fi
echo "  y - Copy (yank)"
echo "  p - Paste"
echo "  d - Delete"
echo "  :w - Save"
echo "  :q - Quit"