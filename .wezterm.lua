-- WezTerm configuration with retro synthwave aesthetic
local wezterm = require 'wezterm'
local config = {}

-- Use config builder for newer versions
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Retro synthwave aesthetic
config.color_scheme = 'Synth Midnight Terminal Dark (base16)'

-- Dark purple/blue background like synthwave84
config.colors = {
  background = '#262335',  -- Deep purple-black background
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

return config
