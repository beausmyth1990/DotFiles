-- WezTerm configuration with retro synthwave aesthetic
local wezterm = require 'wezterm'
local config = {}

-- Use config builder for newer versions
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Retro synthwave aesthetic
config.color_scheme = 'Synth Midnight Terminal Dark (base16)'

-- Synthwave sunset background image (Windows path to WSL file)
config.window_background_image = '\\\\wsl.localhost\\Ubuntu-26.04\\home\\beaus\\repos\\DotFiles\\backgrounds\\synthwave-sunset.jpg'

config.window_background_image_hsb = {
  brightness = 0.03,  -- Very dim so text is readable
  hue = 1.0,
  saturation = 1.0,
}

config.window_background_opacity = 1.0

-- Font
config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 11.0

-- Window padding
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false

-- Cursor
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

-- Bell configuration
config.audible_bell = 'SystemBeep'  -- Use system sound
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}
config.colors = {
  visual_bell = '#ff00ff',  -- Bright magenta flash (synthwave aesthetic)
}

-- Bell event handler to show exclamation mark
wezterm.on('bell', function(window, pane)
  window:toast_notification('wezterm', '❗', nil, 500)
end)

return config
