#!/bin/bash
# Install BONSAI GRUB Theme (Based on working Catppuccin structure)

echo "🌱 Installing BONSAI GRUB Theme"
echo "================================"
echo ""
echo "This theme is based on the working Catppuccin theme structure"
echo "but modified to use BONSAI colors and no images."
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run with sudo:"
    echo "sudo ./INSTALL_BONSAI_GRUB.sh"
    exit 1
fi

echo "1. Creating backup of current GRUB config..."
cp /etc/default/grub /etc/default/grub.backup.$(date +%Y%m%d_%H%M%S)

echo "2. Copying BONSAI theme to /boot/grub/themes/bonsai/"
mkdir -p /boot/grub/themes/bonsai
cp dotfiles/usr/share/grub/themes/bonsai/theme.txt /boot/grub/themes/bonsai/
cp dotfiles/usr/share/grub/themes/bonsai/font.pf2 /boot/grub/themes/bonsai/

echo "3. Setting correct permissions (matching Catppuccin)..."
chmod 755 /boot/grub/themes/bonsai
chmod 644 /boot/grub/themes/bonsai/theme.txt
chmod 644 /boot/grub/themes/bonsai/font.pf2

echo "4. Verifying installation..."
if [ -f /boot/grub/themes/bonsai/theme.txt ] && [ -f /boot/grub/themes/bonsai/font.pf2 ]; then
    echo "   ✓ Theme files installed successfully"
    ls -la /boot/grub/themes/bonsai/
else
    echo "   ✗ Installation failed!"
    exit 1
fi

echo "5. Updating GRUB configuration..."
cp dotfiles/etc/default/grub /etc/default/grub

echo "6. Regenerating GRUB..."
grub-mkconfig -o /boot/grub/grub.cfg

echo ""
echo "✅ BONSAI GRUB Theme installed!"
echo ""
echo "Theme features:"
echo "  • Based on working Catppuccin theme structure"
echo "  • BONSAI color palette (greens, muted colors)"
echo "  • No PNG/image files (text-only design)"
echo "  • Includes required font.pf2 file"
echo "  • Clean, minimal aesthetic"
echo ""
echo "Reboot to see your new BONSAI GRUB theme!"
echo ""
echo "If you encounter any issues:"
echo "  1. The theme is at: /boot/grub/themes/bonsai/"
echo "  2. Your backup is at: /etc/default/grub.backup.*"
echo "  3. To restore: sudo cp /etc/default/grub.backup.* /etc/default/grub"