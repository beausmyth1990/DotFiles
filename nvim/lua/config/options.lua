-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Semi-transparent floating windows and popups
vim.opt.winblend = 15 -- Floating window transparency (0 = opaque, 100 = fully transparent)
vim.opt.pumblend = 15 -- Popup menu transparency

-- Use TokyoNight's built-in transparency (let colorscheme handle backgrounds)
-- The transparent = true in colorscheme.lua already makes panels semi-transparent
