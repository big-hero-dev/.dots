
# Fix the internet wired network
Create the file /etc/systemd/network/20-wired.network

```
[Match]
Name=en*
Name=eth*

[Network]
DHCP=yes
```

Then either restart or start:
```
sudo systemctl start systemd-networkd
sudo systemctl start systemd-resolved
```

# Fix icon cursor X11
You'd need to put your mouse cursor theme in _/usr/share/icons/_ , however if you already have a cursor theme in your $HOME I think it would be better if you make a symlink instead.

Now edit _/usr/share/icons/default/index.theme_ and edit Inherits= to the name of your cursor's theme.

# Install antfu/ni with Bun

```
bun add -g @antfu/ni
```
# Ai-Commit & Ollama
```
npm install -g https://github.com/insulineru/ai-commit
```

# Fix vlc error h264
install vlc-plugin-ffmpeg
