# Helper function: prints Amstrad CPC 464 banner only in terminal with amstrad-cpc464 active
_amstrad_cpc464_banner() {
    if [[ -r "/proc/$PPID/comm" && "$(< /proc/$PPID/comm)" == @(foot*|alacritty|kitty|ghostty) ]]; then
        if [[ "$(cat ~/.local/state/omarchy/current/theme.name 2>/dev/null)" == "amstrad-cpc464" ]] || \
           grep -q "Amstrad CPC 464" ~/.local/state/omarchy/current/theme/colors.toml 2>/dev/null; then
            printf '\e[33m'
            printf ' Amstrad 64K Microcomputer  (v1)\n\n'
            printf ' ©1984 Amstrad Consumer Electronics plc\n'
            printf '          and Locomotive Software Ltd.\n\n'
            printf ' BASIC 1.0\n\n'
            printf 'Ready\n'
            printf '\e[0m'
        fi
    fi
}

# Override clear to wipe the screen and re-display the banner when applicable
clear() {
    command clear "$@"
    _amstrad_cpc464_banner
}

# Clear the screen WITHOUT the banner (classic CLS)
cls() {
    command clear "$@"
}

# Display on initial terminal launch
_amstrad_cpc464_banner
