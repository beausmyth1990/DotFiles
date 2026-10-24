-- Background image support for neovim
return {
  {
    "edluffy/hologram.nvim",
    enabled = false, -- Requires kitty terminal
  },
  {
    -- Alternative: Use terminal background with transparency (recommended)
    -- Set a sunset image in your terminal emulator settings
    -- Windows Terminal: Settings > Profile > Appearance > Background image
    -- Then set Background image opacity to see it through nvim
  },
}
