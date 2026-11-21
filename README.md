# Amstrad CPC 464 Theme for Omarchy 4.5+

An authentic 8-bit retro theme for **Omarchy 4.5 (Quattro)** inspired by the iconic **1984 Amstrad CPC 464** microcomputer (`CTM644` Color CRT monitor, Locomotive BASIC 1.0, and the classic colored mechanical keycaps).

### 🖥️ Workspace & Terminal (`CPC464` Font + Gate Array Palette)
![Amstrad CPC 464 Workspace Preview](screenshots/workspace.png)

### 🎨 Clean Desktop (`OMARCHY` CPC 464 Wallpaper)
![Amstrad CPC 464 Desktop Preview](screenshots/desktop.png)

---

## ✨ Features

* **Authentic Gate Array Color Palette (`colors.toml`):**
  * Royal Blue CRT screen backdrop (`#000052`) tuned for comfortable daily coding and reading.
  * Locomotive BASIC Ink 1 Bright Yellow (`#ffff00`) accents and block cursor, paired with warm cream-yellow (`#f2f27a`) primary text.
  * ANSI colors mapped directly to the Amstrad Gate Array hardware pens and classic **Red** (`ESC`/`STOP`), **Green** (`SHIFT`/`COPY`), and **Blue** (`ENTER`/Numpad) keycaps.
  * 45-degree **Red → Green → Blue** active window border gradient in Hyprland.
* **Sharp 8-Bit UI Geometry (`shell.controls.toml`):** Zero corner radius (`corner-radius = 0`) across Quickshell surfaces with high-contrast red/yellow interactive highlights.
* **Native Multi-Terminal Color Generation:** Automatically styles **Foot**, **Ghostty**, **Alacritty**, and **Kitty** directly from `colors.toml` when the theme is selected.
- **Optional Pixel Font Included (`extras/CPC464.ttf`):** Ships the pixel-accurate 1984 **CPC464** TrueType font if you want to pair the color scheme with authentic 8-bit typography.
* **7 Curated Wallpapers (`backgrounds/`):** Cycle through custom Omarchy-styled Amstrad graphics, hardware photography, and Locomotive BASIC backdrops using `Super + Ctrl + Space`.

---

## 🚀 Installation

### Install the theme directly via Omarchy

```bash
omarchy theme install https://github.com/DavidSom-IT/amstrad-cpc464
```

### Optional: Installing the `CPC464` Pixel Font
If you would like to use the included 1984 Amstrad pixel font in your terminal:

```bash
mkdir -p ~/.local/share/fonts
cp ~/.config/omarchy/themes/amstrad-cpc464/extras/CPC464.ttf ~/.local/share/fonts/
fc-cache -f
```
You can then select `CPC464` via `omarchy font set "CPC464"` or in your terminal configuration.

### Optional: Locomotive BASIC 1.0 Startup Banner (`~/.bashrc`)

If you want your terminal (**Foot**, **Ghostty**, **Alacritty**, or **Kitty**) to display the classic **1984 Locomotive BASIC 1.0 `Ready`** startup prompt whenever the **Amstrad CPC 464** theme is active—along with `clear` (keeps the header) and `cls` (wipes completely blank)—run this command to append the snippet to your `~/.bashrc`:

```bash
cat << 'EOF' >> ~/.bashrc

# Amstrad CPC 464 Theme Startup Banner
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

clear() {
    command clear "$@"
    _amstrad_cpc464_banner
}

cls() {
    command clear "$@"
}

_amstrad_cpc464_banner
EOF
source ~/.bashrc
```

### Optional: Auto-Launch Terminal on Boot (`~/.config/hypr/autostart.lua`)

If you want Omarchy to boot straight into the `Ready` prompt whenever the **Amstrad CPC 464** theme is active (while leaving startup untouched for all other themes), run this command:

```bash
mkdir -p ~/.config/hypr
if ! grep -Fq "BEGIN AMSTRAD CPC 464 AUTOSTART" ~/.config/hypr/autostart.lua 2>/dev/null; then
  cat << 'EOF' >> ~/.config/hypr/autostart.lua

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
fi
```

---

## 📁 Repository Structure

```text
amstrad-cpc464/
├── backgrounds/           # 7 Amstrad CPC 464 & Omarchy-styled wallpapers
├── extras/
│   └── CPC464.ttf         # Amstrad CPC 464 pixel font
├── screenshots/           # Preview screenshots for README
├── colors.toml            # Gate Array & CTM644 CRT color definitions
├── icons.theme            # Yaru-yellow icon theme definition
├── preview.png            # Theme picker preview screenshot
├── README.md              # Documentation & credits
└── shell.controls.toml    # Sharp 0px corner radius & retro control colors
```

---

## 🙏 Credits & Attribution

* **Theme Design, Integration & Custom Wallpapers:**
  * Created by **David Som ([@DavidSom-IT](https://github.com/DavidSom-IT))**.
  * Wallpapers `01` and `07` were originally generated via the terminal using **ImageMagick** and the Omarchy font.
* **Font:**
  * **CPC464 Font** by **Dmian** — sourced from [codeberg.org/Dmian/font-cpc464](https://codeberg.org/Dmian/font-cpc464), reproducing the original 1984 Amstrad CPC 464 ROM character set.
* **Community Wallpapers (via WallpaperCave):**
  * `02-amstrad-closeup-high.webp` — Uploaded by [lucrece143](https://wallpapercave.com/u/lucrece143)
  * `03-amstrad-cpc464-color-closeup-high.webp` — Uploaded by [freibeuter](https://wallpapercave.com/u/freibeuter)
  * `04-amstrad-logo-high.png` — Uploaded by [user](https://wallpapercave.com/u/user)
  * `05-locomotive-basic-ready.png` — Uploaded by [hrn78](https://wallpapercave.com/u/hrn78)
  * `06-locomotive-basic-high.png` — Uploaded by [jessica_53429](https://wallpapercave.com/u/jessica_53429)
* **Trademarks:**
  * *Amstrad*, *CPC 464*, and *Locomotive BASIC* are historical trademarks of Amstrad Consumer Electronics plc and Locomotive Software Ltd.

> *Disclaimer: Hardware photography and the ROM-derived font remain the property of their respective creators. This is a free, non-commercial community tribute theme. If you are the creator of an asset included here and would like it credited differently or removed, please open an issue.*
