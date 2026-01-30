- **Window Manager** :bento: [Niri](https://github.com/YaLTeR/niri) (Scrollable Tiling)
- **Status Bar** :chocolate_bar: Waybar (Niri module)
- **Application Launcher** :rocket: Fuzzel
- **Notification Daemon** :loudspeaker: Mako
- **Shell** :fish: [Fish](https://fishshell.com/)
- **File Manager** :duck: [Yazi](https://yazi-rs.github.io/docs/)
- **Editor** :fire: [Neovim](https://github.com/neovim/neovim) (>= 0.11)

---
_Warning :rotating_light: Don't blindly use my settings unless you know what that entails. Use at your own risk!_

_Note :wrench: I use colemak-dh keyboard layout_

### Required
- `nodejs`, `npm`
- `rustup default nightly`
- `xwayland-satellite` (For X11 apps support in Niri)

```fish
fisher install jorgebucaran/nvm.fish
fisher install rstacruz/fish-npm-global

```

### Shell setup

* [starship](https://starship.rs/) - Shell theme
* [zoxide](https://github.com/ajeetdsouza/zoxide) - Directory jumping
* [peco](https://github.com/peco/peco) - Interactive filtering
* [tmux](https://github.com/tmux/tmux) - Terminal multiplexer
* [tpm](https://github.com/tmux-plugins/tpm) - Tmux Plugin Manager

### Font

* Font Awesome 6 Pro
* Noto Sans Mono CJK / Icons
* JetBrains Mono / SpaceMono Nerd Font
* Lexend

### Devtool

* `hyperfine`: Benchmarking tool.
* `translate-shell`: CLI translation.
* `bun`: JavaScript runtime.
* `@antfu/ni`: Package manager switcher.

### Tool

* `pavucontrol` / `pamixer`: Audio control.
* `brightnessctl`: Backlight control.
* `grim` + `slurp`: Screenshot core.
* `swappy`: Screenshot editor.
* `wl-clipboard`: Wayland clipboard tool.
* `glow`: Render markdown on the CLI.
* `paleta`: Color palettes.

### Input method

* fcitx5-unikey
* fcitx5-chinese-addons

### App

* WebCatalog Desktop
* Pomotroid
* Grub-customizer

### NIRI STACK (Optimized)

```bash
# Core & Layout
niri xwayland-satellite

# Desktop Components
waybar foot mako fuzzel

# Wallpaper & Lock (Wayland native)
swaybg hyprlock hypridle

# Utilities
grim slurp wl-clipboard swappy imv hyprpicker
xdg-desktop-portal-gnome
