local wezterm = require("wezterm")

-- WezTerm Retro CRT Terminal Configuration
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "nord"

-- Font Settings
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
})
config.font_size = 16

-- CRT Effect Settings
config.window_background_opacity = 0.9
config.text_background_opacity = 1.0

-- Cursor Style
config.default_cursor_style = "BlinkingUnderline"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.force_reverse_video_cursor = false

-- Window Appearance
config.window_decorations = "NONE"
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}

-- Enable blur effect (tùy theo OS)
config.macos_window_background_blur = 20
config.win32_system_backdrop = "Acrylic"

-- Tab Bar
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false

-- Performance
config.max_fps = 60
config.animation_fps = 60

-- Additional visual effects
config.bold_brightens_ansi_colors = true

-- Scrollback
config.scrollback_lines = 10000

config.foreground_text_hsb = {
	hue = 1.0,
	saturation = 1.2,
	brightness = 1.1,
}

config.disable_default_key_bindings = true

config.use_ime = true

return config
