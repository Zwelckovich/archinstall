#!/bin/bash

# ╭─────────────────────────────────────────────────────────────────────────────╮
# │ 🌱 BONSAI Calcurse Keys Validator                                           │
# │ Checks for conflicts in keybindings configuration                          │
# ╰─────────────────────────────────────────────────────────────────────────────╯

KEYS_FILE="$HOME/.config/calcurse/keys"

if [[ ! -f "$KEYS_FILE" ]]; then
    echo "❌ Keys file not found at $KEYS_FILE"
    exit 1
fi

echo "🌱 Validating calcurse keybindings..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Extract all key assignments
declare -A key_commands
declare -A command_keys

while IFS= read -r line; do
    # Skip comments and empty lines
    [[ "$line" =~ ^#.*$ ]] && continue
    [[ -z "$line" ]] && continue
    
    # Parse command and keys
    if [[ "$line" =~ ^([a-z-]+)[[:space:]]+(.+)$ ]]; then
        command="${BASH_REMATCH[1]}"
        keys="${BASH_REMATCH[2]}"
        
        # Store command and its keys
        command_keys["$command"]="$keys"
        
        # Check each key
        for key in $keys; do
            if [[ -n "${key_commands[$key]}" ]]; then
                echo "⚠️  Conflict: '$key' assigned to both '$command' and '${key_commands[$key]}'"
            else
                key_commands["$key"]="$command"
            fi
        done
    fi
done < "$KEYS_FILE"

echo ""
echo "📋 Summary of keybindings:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Show vim navigation
echo "🎯 Vim Navigation:"
echo "  h → ${key_commands[h]:-unassigned}"
echo "  j → ${key_commands[j]:-unassigned}"
echo "  k → ${key_commands[k]:-unassigned}"
echo "  l → ${key_commands[l]:-unassigned}"

echo ""
echo "📜 Scrolling:"
echo "  C-d → ${key_commands[C-d]:-unassigned}"
echo "  C-b → ${key_commands[C-b]:-unassigned} (vim alternative to C-u)"

echo ""
echo "💾 System:"
echo "  Q → ${key_commands[Q]:-unassigned} (capital Q for quit)"
echo "  C-r → ${key_commands[C-r]:-unassigned} (refresh)"
echo "  s → ${key_commands[s]:-unassigned} (save)"

# Count total keys
total_commands=$(echo "${!command_keys[@]}" | wc -w)
total_keys=$(echo "${!key_commands[@]}" | wc -w)

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Total commands configured: $total_commands"
echo "✅ Total keys mapped: $total_keys"

# Check for any remaining conflicts
if grep -q "⚠️  Conflict" <<< "$(declare -p key_commands 2>/dev/null)"; then
    echo "❌ Conflicts detected - please review above"
    exit 1
else
    echo "🌱 No conflicts detected - keybindings are valid!"
fi