#!/bin/bash
# ╭─────────────────────────────────────────────────────────────────────────────╮
# │ 🌱 BONSAI HTML Email Viewer                                                 │
# │ Opens HTML email in browser with BONSAI styling                            │
# ╰─────────────────────────────────────────────────────────────────────────────╯

# Create temporary file
tmpfile=$(mktemp /tmp/mutt-html-XXXXXX.html)
cat > "$tmpfile"

# Inject BONSAI styling into HTML
sed -i '/<\/head>/i \
<style>\
  body { \
    background: #0a0e14; \
    color: #e6e8eb; \
    font-family: "Quicksand", system-ui, sans-serif; \
    padding: 2rem; \
    max-width: 800px; \
    margin: 0 auto; \
    line-height: 1.6; \
  } \
  a { \
    color: #82a4c7; \
    text-decoration: none; \
  } \
  a:hover { \
    color: #9bb5d4; \
    text-decoration: underline; \
  } \
  blockquote { \
    border-left: 3px solid #7c9885; \
    padding-left: 1rem; \
    color: #8b92a5; \
    margin: 1rem 0; \
  } \
  pre, code { \
    background: #151922; \
    border: 1px solid #2d3441; \
    border-radius: 4px; \
    padding: 0.5rem; \
    font-family: "JetBrains Mono", monospace; \
  } \
  table { \
    border-collapse: collapse; \
    width: 100%; \
    margin: 1rem 0; \
  } \
  th, td { \
    border: 1px solid #2d3441; \
    padding: 0.5rem; \
    text-align: left; \
  } \
  th { \
    background: #151922; \
    color: #7c9885; \
  } \
  img { \
    max-width: 100%; \
    height: auto; \
    border-radius: 8px; \
  } \
</style>' "$tmpfile"

# If no head tag exists, add one with styling
if ! grep -q '</head>' "$tmpfile"; then
    sed -i '1i \
<html><head>\
<meta charset="UTF-8">\
<style>\
  body { background: #0a0e14; color: #e6e8eb; font-family: "Quicksand", system-ui, sans-serif; padding: 2rem; max-width: 800px; margin: 0 auto; line-height: 1.6; } \
  a { color: #82a4c7; text-decoration: none; } \
  a:hover { color: #9bb5d4; text-decoration: underline; } \
  blockquote { border-left: 3px solid #7c9885; padding-left: 1rem; color: #8b92a5; margin: 1rem 0; } \
  pre, code { background: #151922; border: 1px solid #2d3441; border-radius: 4px; padding: 0.5rem; font-family: "JetBrains Mono", monospace; } \
</style>\
</head><body>' "$tmpfile"
    echo '</body></html>' >> "$tmpfile"
fi

# Open in browser (check for LibreWolf first, then fallback)
if command -v librewolf &> /dev/null; then
    librewolf "$tmpfile" &
elif [ -n "$BROWSER" ]; then
    $BROWSER "$tmpfile" &
else
    firefox "$tmpfile" &
fi

# Clean up after a delay
(sleep 10 && rm -f "$tmpfile") &