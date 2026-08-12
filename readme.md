# dotfiles

* **Desktop Environment** :bento: [KDE Plasma 6](https://kde.org/plasma-desktop/) (Wayland)
* **Terminal Shell** :fish: [Fish](https://fishshell.com/)
* **Terminal Emulator** :terminal: [Konsole](https://konsole.kde.org/) / [Foot](https://codeberg.org/dnkl/foot)
* **File Manager** :duck: [Yazi](https://yazi-rs.github.io/docs/) & Dolphin
* **Editor** :fire: [Neovim](https://github.com/neovim/neovim) (>= 0.11)

---

*Warning :rotating_light: Don't blindly use my settings unless you know what that entails. Use at your own risk!*

*Note :wrench: I use Colemak-DH keyboard layout*

### Required

* `nodejs`, `npm`
* `rustup default nightly`
* `plymouth` (For Apple boot logo splash)

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

### Boot Experience (Apple Logo)

* `plymouth-theme-apple-bgrt` / `plymouth-theme-monarch-apple` - Apple logo splash screen on boot.

```bash
yay -S plymouth-theme-apple-bgrt
sudo plymouth-set-default-theme -R apple-bgrt

```

### Font

* Noto Sans Mono CJK / Icons
* JetBrains Mono
* Terminus
* Unifont (gnu-free-font)

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
* `cliphist`: Clipboard history manager.

### Input method

* fcitx5-unikey
* fcitx5-chinese-addons

### App

* Responsively App
* WebCatalog Desktop

---

# KDE PLASMA STACK

### Core & Desktop

* `plasma-desktop`
* `kwin` (Wayland)
* `plasma-browser-integration`
* `sddm` (Display Manager)

### Screen & Screenshot

* `spectacle` / (`grim` + `slurp` + `swappy`)
* `imv` (Image viewer)
