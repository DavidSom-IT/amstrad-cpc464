#!/usr/bin/env bash
set -e

THEME_NAME="amstrad-cpc464"
THEME_DIR="$HOME/.config/omarchy/themes/$THEME_NAME"
HOOK_FILE="$HOME/.config/omarchy/hooks/theme-set.d/theme-set-amstrad"
AUTOSTART_LUA="$HOME/.config/hypr/autostart.lua"
FOOT_INI="$HOME/.config/foot/foot.ini"

# Optional: Run ./install.sh --uninstall to cleanly revert everything
if [[ "${1:-}" == "--uninstall" ]]; then
    echo "Removing Amstrad CPC 464 theme integrations..."
    rm -f "$HOOK_FILE"
    [[ -f "$HOME/.bashrc" ]] && sed -i '/# Amstrad CPC 464 Theme Integration/d; /amstrad-bashrc\.sh/d' "$HOME/.bashrc"
    [[ -f "$AUTOSTART_LUA" ]] && sed -i '/-- BEGIN AMSTRAD CPC 464 AUTOSTART/,/-- END AMSTRAD CPC 464 AUTOSTART/d' "$AUTOSTART_LUA"
    echo "Uninstalled Amstrad CPC 464 hooks and startup rules."
    exit 0
fi

echo "Installing Amstrad CPC 464 theme extras..."

# 1. Install the CPC464 font into ~/.local/share/fonts
if compgen -G "$THEME_DIR/extras/*.{ttf,otf,TTF,OTF}" > /dev/null 2>&1 || \
   ls "$THEME_DIR/extras/"*.ttf "$THEME_DIR/extras/"*.otf > /dev/null 2>&1; then
    mkdir -p "$HOME/.local/share/fonts"
    cp -f "$THEME_DIR/extras/"*.{ttf,otf,TTF,OTF} "$HOME/.local/share/fonts/" 2>/dev/null || true
    fc-cache -f
    echo "✓ Installed CPC464 font."
fi

# 2. Ensure ~/.config/foot/foot.ini puts include= AFTER font= so theme font overrides work
if [[ -f "$FOOT_INI" ]]; then
    sed -i 's|^# *font=\(.*\)|font=\1|' "$FOOT_INI"
    if grep -q "^include=.*/current/theme/foot.ini" "$FOOT_INI" && grep -q "^font=" "$FOOT_INI"; then
        sed -i '\@^include=.*/current/theme/foot.ini@d' "$FOOT_INI"
        sed -i '/^font=/a include=~/.local/state/omarchy/current/theme/foot.ini' "$FOOT_INI"
    fi
    echo "✓ Verified Foot terminal font override order."
fi

# 3. Create theme-set hook so supported terminals use CPC464:size=10 when amstrad-cpc464 is active
mkdir -p "$HOME/.config/omarchy/hooks/theme-set.d"
cat << 'EOF' > "$HOOK_FILE"
#!/usr/bin/env bash
STATE_THEME="$HOME/.local/state/omarchy/current/theme"

if [[ "$1" == "amstrad-cpc464" ]] || \
   [[ "$(cat "$HOME/.local/state/omarchy/current/theme.name" 2>/dev/null)" == "amstrad-cpc464" ]] || \
   grep -q "Amstrad CPC 464" "$STATE_THEME/colors.toml" 2>/dev/null; then

    # Foot
    if [[ -f "$STATE_THEME/foot.ini" ]] && ! grep -q "font=CPC464" "$STATE_THEME/foot.ini"; then
        sed -i '1i [main]\nfont=CPC464:size=10\n' "$STATE_THEME/foot.ini"
    fi

    # Ghostty
    if [[ -f "$STATE_THEME/ghostty.conf" ]] && ! grep -q "CPC464" "$STATE_THEME/ghostty.conf"; then
        printf '\nfont-family = "CPC464"\nfont-size = 10\n' >> "$STATE_THEME/ghostty.conf"
    fi

    # Alacritty
    if [[ -f "$STATE_THEME/alacritty.toml" ]] && ! grep -q "CPC464" "$STATE_THEME/alacritty.toml"; then
        printf '\n[font]\nnormal = { family = "CPC464" }\nsize = 10.0\n' >> "$STATE_THEME/alacritty.toml"
    fi

    # Kitty
    if [[ -f "$STATE_THEME/kitty.conf" ]] && ! grep -q "CPC464" "$STATE_THEME/kitty.conf"; then
        printf '\nfont_family CPC464\nfont_size 10.0\n' >> "$STATE_THEME/kitty.conf"
    fi
fi
EOF
chmod +x "$HOOK_FILE"
echo "✓ Installed Omarchy theme-set hook (Foot, Ghostty, Alacritty, Kitty)."

# 4. Source amstrad-bashrc.sh in ~/.bashrc if not already present
SOURCE_LINE="[[ -r ~/.config/omarchy/themes/$THEME_NAME/extras/amstrad-bashrc.sh ]] && source ~/.config/omarchy/themes/$THEME_NAME/extras/amstrad-bashrc.sh"
if ! grep -Fq "amstrad-bashrc.sh" "$HOME/.bashrc" 2>/dev/null; then
    printf "\n# Amstrad CPC 464 Theme Integration\n%s\n" "$SOURCE_LINE" >> "$HOME/.bashrc"
    echo "✓ Linked Locomotive BASIC startup banner in ~/.bashrc."
fi

# 5. Configure Hyprland autostart.lua to open terminal on boot ONLY for amstrad-cpc464
mkdir -p "$HOME/.config/hypr"
if ! grep -Fq "BEGIN AMSTRAD CPC 464 AUTOSTART" "$AUTOSTART_LUA" 2>/dev/null; then
    [[ -f "$AUTOSTART_LUA" ]] && sed -i '/^o\.launch_on_start("omarchy-launch-terminal")$/d' "$AUTOSTART_LUA"
    cat << 'EOF' >> "$AUTOSTART_LUA"

-- BEGIN AMSTRAD CPC 464 AUTOSTART
local f = io.open(os.getenv("HOME") .. "/.local/state/omarchy/current/theme.name", "r")
if f then
    local active_theme = f:read("*l")
    f:close()
    if active_theme == "amstrad-cpc464" then
        o.launch_on_start("omarchy-launch-terminal")
    end
end
-- END AMSTRAD CPC 464 AUTOSTART
EOF
    echo "✓ Added conditional terminal autostart to ~/.config/hypr/autostart.lua."
fi

# Apply the hook immediately if the theme is already active
"$HOOK_FILE" "$(cat ~/.local/state/omarchy/current/theme.name 2>/dev/null)"

echo ""
echo "Ready! Open a new terminal to see the Amstrad CPC 464 font and Locomotive BASIC 1.0 screen."
