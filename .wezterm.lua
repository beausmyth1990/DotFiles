-- WezTerm configuration with retro synthwave aesthetic
local wezterm = require 'wezterm'
local config = {}

-- Use config builder for newer versions
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Retro synthwave aesthetic
config.color_scheme = 'Synth Midnight Terminal Dark (base16)'

-- Synthwave sunset background image
config.window_background_image = wezterm.home_dir .. '/repos/DotFiles/backgrounds/synthwave-sunset.jpg'

config.window_background_image_hsb = {
  brightness = 0.03,  -- Very dim so text is readable
  hue = 1.0,
  saturation = 1.0,
}

config.window_background_opacity = 0.9

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

return config
