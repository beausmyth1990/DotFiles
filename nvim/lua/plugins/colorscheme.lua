-- Cyberpunk / synthwave colorscheme contenders.
-- Try each live with `:colorscheme <name>`, then set the winner
-- in the LazyVim opts block at the bottom.
return {
  -- synthwave84: retro 80s sunset (hot pink / orange / purple)
  { "LunarVim/synthwave84.nvim" },

  -- cyberdream: high-contrast neon cyberpunk
  { "scottmckendry/cyberdream.nvim", lazy = false, priority = 1000 },

  -- tokyonight: ships with LazyVim, neon-accented deep blues
  { "folke/tokyonight.nvim" },

  -- Set the active colorscheme here (change the string to switch)
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cyberdream",
    },
  },
}
