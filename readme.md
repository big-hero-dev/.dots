# dotfiles

- **Window Manager** :bento: [Niri](https://github.com/YaLTeR/niri) (Scrollable Tiling)
- **Shell** :shell: [Noctalia Shell](https://noctalia.dev) (Bar, Launcher, Notifications, Wallpaper)
- **Application Launcher** :rocket: Noctalia Launcher (built-in)
- **Notification Daemon** :loudspeaker: Noctalia Notifications (built-in)
- **Terminal Shell** :fish: [Fish](https://fishshell.com/)
- **File Manager** :duck: [Yazi](https://yazi-rs.github.io/docs/)
- **Editor** :fire: [Neovim](https://github.com/neovim/neovim) (>= 0.11)

---

_Warning :rotating_light: Don't blindly use my settings unless you know what that entails. Use at your own risk!_
_Note :wrench: I use colemak-dh keyboard layout_

### Required

- `nodejs`, `npm`
- `rustup default nightly`
- `xwayland-satellite` (For X11 apps support in Niri)
- [Quickshell](https://quickshell.outfoxxed.me/) (required by Noctalia Shell)

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
* `cliphist`: Manager clipboard history.

### Input method

* fcitx5-unikey
* fcitx5-chinese-addons

### App

* WebCatalog Desktop
* Pomotroid
* Grub-customizer

# NIRI STACK (Optimized)

# Core & Layout
niri xwayland-satellite

# Desktop Components
noctalia-shell

# Utilities
grim slurp wl-clipboard swappy imv 
xdg-desktop-portal-gtk xdg-desktop-portal
greetd greetd-tuigreet plasma-browser-integration
```

### Theming
* `pywal` (wal): Color scheme generator
* `pywalfox` (pipx): Apply pywal colors to Firefox
