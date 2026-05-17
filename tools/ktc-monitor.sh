#!/usr/bin/env bash
# ktc-monitor.sh - one-button display switch for the KTC M27P6 arrival.
#
# Tomorrow's hardware change: KTC M27P6 on DisplayPort (DP-1), ASUS PB278 stays
# on its HDMI port (remains HDMI-A-2), LG ultrawide (HDMI-A-1) removed.
#
# This rewrites the MONITORS block, the 10 workspace bindings, and the screenshot
# bind in the desktop hyprland.conf, then reloads Hyprland live (no reboot).
# It is idempotent: running it twice produces an identical file.
#
#   ktc-monitor.sh              apply the KTC profile + reload   (the one button)
#   ktc-monitor.sh --safe       like apply but 4K@120 + 8-bit (DSC fallback)
#   ktc-monitor.sh --revert     restore the original dual-HDMI (ASUS + LG) layout
#   ktc-monitor.sh --vrr-on     re-apply KTC profile with VRR enabled
#   ktc-monitor.sh --vrr-off    re-apply KTC profile with VRR disabled
#   ktc-monitor.sh --dry-run    show the diff it would apply; no write, no reload
#   ktc-monitor.sh --help       this help
#
# --dry-run composes with the others, e.g.  ktc-monitor.sh --revert --dry-run

set -euo pipefail

# --- BONSAI palette (matches install.sh) -----------------------------------
BONSAI_GREEN="\e[38;2;124;152;133m"
BONSAI_BLUE="\e[38;2;130;164;199m"
BONSAI_YELLOW="\e[38;2;199;168;130m"
BONSAI_RED="\e[38;2;199;130;137m"
BONSAI_TEXT="\e[38;2;230;232;235m"
BONSAI_MUTED="\e[38;2;139;146;165m"
BONSAI_RESET="\e[0m"
CNT="${BONSAI_BLUE}[→]${BONSAI_RESET}"
COK="${BONSAI_GREEN}[✓]${BONSAI_RESET}"
CER="${BONSAI_RED}[✗]${BONSAI_RESET}"
CAT="${BONSAI_YELLOW}[!]${BONSAI_RESET}"

say()  { echo -e "$1"; }
die()  { echo -e "${CER} ${BONSAI_RED}$1${BONSAI_RESET}" >&2; exit 1; }

# --- target file ------------------------------------------------------------
# Canonical git-tracked desktop config. ~/.config/hypr is a symlinked dir into
# this path, so editing here updates the live config that hyprctl reload reads.
CONF="${HOME}/archinstall/dotfiles/config/hypr/desktop/.config/hypr/hyprland.conf"

# --- dependency guard (installs nothing - these ship with base + hyprland) --
for bin in awk diff cp grep mktemp; do
  command -v "$bin" >/dev/null 2>&1 || die "required tool '$bin' is missing (expected from coreutils/gawk/diffutils)"
done
[ -f "$CONF" ] || die "config not found: $CONF"

# --- arg parsing ------------------------------------------------------------
MODE="apply"      # apply | safe | revert
VRR="off"         # off | on
DRY=0
for arg in "$@"; do
  case "$arg" in
    --safe)     MODE="safe" ;;
    --revert)   MODE="revert" ;;
    --vrr-on)   MODE="apply"; VRR="on" ;;
    --vrr-off)  MODE="apply"; VRR="off" ;;
    --dry-run)  DRY=1 ;;
    -h|--help)  awk 'NR>1 && /^#/ {sub(/^# ?/,""); print; next} NR>1 {exit}' "$0"; exit 0 ;;
    *)          die "unknown argument: $arg  (try --help)" ;;
  esac
done

# --- build the desired managed lines for the chosen mode --------------------
# Screenshot bind kept byte-identical to the original except the -o output.
grim_line() { echo "bind = \$mainMod, Print, exec, grim -o ${1} ~/Pictures/\$(date +'screenshot_%s.png')"; }

ws_block() {  # $1 = monitor for ws 1-5, $2 = monitor for ws 6-10
  local a="$1" b="$2"
  cat <<EOF
workspace = 1,monitor:${a},default:true,persistent:true
workspace = 2,monitor:${a},persistent:true
workspace = 3,monitor:${a},persistent:true
workspace = 4,monitor:${a},persistent:true
workspace = 5,monitor:${a},persistent:true
workspace = 6,monitor:${b},default:true,persistent:true
workspace = 7,monitor:${b},persistent:true
workspace = 8,monitor:${b},persistent:true
workspace = 9,monitor:${b},persistent:true
workspace = 10,monitor:${b},persistent:true
EOF
}

case "$MODE" in
  apply)
    dp="monitor= DP-1,3840x2160@160,0x0,1.5,bitdepth,10"
    [ "$VRR" = "on" ] && dp="${dp},vrr,1"
    MON="${dp}"$'\n'"monitor= HDMI-A-2,preferred,2560x0,1"
    WS="$(ws_block DP-1 HDMI-A-2)"
    GRIM="$(grim_line DP-1)"
    DESC="KTC M27P6 on DP-1 (3840x2160@160, scale 1.5, 10-bit, VRR ${VRR}); ASUS HDMI-A-2 right"
    ;;
  safe)
    MON="monitor= DP-1,3840x2160@120,0x0,1.5"$'\n'"monitor= HDMI-A-2,preferred,2560x0,1"
    WS="$(ws_block DP-1 HDMI-A-2)"
    GRIM="$(grim_line DP-1)"
    DESC="SAFE fallback: KTC on DP-1 (3840x2160@120, no 10-bit/VRR); ASUS HDMI-A-2 right"
    ;;
  revert)
    MON="monitor= HDMI-A-2,preferred,0x0,1"$'\n'"monitor= HDMI-A-1,preferred,2560x0,1"
    WS="$(ws_block HDMI-A-2 HDMI-A-1)"
    GRIM="$(grim_line HDMI-A-2)"
    DESC="REVERT: original dual-HDMI layout (ASUS HDMI-A-2 + LG HDMI-A-1)"
    ;;
esac

# --- transform into a temp file --------------------------------------------
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

# Pass 1: rewrite monitor / workspace / grim lines by structural position.
# Matching active (non-commented) lines only, so it is state-independent
# (works the same whether the file is currently KTC, safe, or dual-HDMI).
MON="$MON" WS="$WS" GRIM="$GRIM" awk '
  function emit(s,   n,a,i){ n=split(s,a,"\n"); for(i=1;i<=n;i++) print a[i] }
  /^monitor= /                                  { if(!m){emit(ENVIRON["MON"]);  m=1} next }
  /^workspace = [0-9]/                           { if(!w){emit(ENVIRON["WS"]);   w=1} next }
  /^bind = \$mainMod, Print, exec, grim -o /     { print ENVIRON["GRIM"]; next }
  { print }
' "$CONF" > "$TMP"

# Pass 2: VRR keyword inside the misc { } block (only for the apply mode).
if [ "$MODE" = "apply" ]; then
  TMP2="$(mktemp)"
  VRR="$VRR" awk '
    /^misc \{/ { print; inmisc=1; if(ENVIRON["VRR"]=="on") print "    vrr = 1"; next }
    inmisc && /^\}/ { inmisc=0; print; next }
    inmisc && /^[[:space:]]*vrr[[:space:]]*=/ { next }   # we manage this line
    { print }
  ' "$TMP" > "$TMP2"
  mv "$TMP2" "$TMP"
fi

# --- dry-run: show diff, change nothing ------------------------------------
if [ "$DRY" -eq 1 ]; then
  say "${CNT} ${BONSAI_TEXT}Dry run - ${DESC}${BONSAI_RESET}"
  if diff -u "$CONF" "$TMP" >/dev/null; then
    say "${COK} ${BONSAI_TEXT}No changes - config already in this state (idempotent).${BONSAI_RESET}"
  else
    diff -u "$CONF" "$TMP" || true
    say "${CAT} ${BONSAI_MUTED}Above is what would change. Nothing was written.${BONSAI_RESET}"
  fi
  exit 0
fi

# --- apply ------------------------------------------------------------------
if diff -q "$CONF" "$TMP" >/dev/null; then
  say "${COK} ${BONSAI_TEXT}Config already matches: ${DESC}${BONSAI_RESET}"
else
  [ -f "${CONF}.bak" ] || { cp -a "$CONF" "${CONF}.bak"; say "${CNT} ${BONSAI_MUTED}Backup written: ${CONF}.bak${BONSAI_RESET}"; }
  cp -a "$TMP" "$CONF"
  say "${COK} ${BONSAI_TEXT}Applied: ${DESC}${BONSAI_RESET}"
fi

# --- reload Hyprland (graceful if no session) ------------------------------
if command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1; then
  say "${COK} ${BONSAI_TEXT}Hyprland reloaded.${BONSAI_RESET}"
  say "${CNT} ${BONSAI_MUTED}Current outputs:${BONSAI_RESET}"
  hyprctl monitors all 2>/dev/null | grep -E '^Monitor |^\s+[0-9]+x[0-9]+@|scale:' || true
else
  say "${CAT} ${BONSAI_YELLOW}Could not reload (no live Hyprland session?). Config is saved and will apply on next login.${BONSAI_RESET}"
fi
