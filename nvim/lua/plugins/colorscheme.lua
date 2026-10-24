-- Cyberpunk / synthwave colorscheme contenders.
-- Try each live with `:colorscheme <name>`, then set the winner
-- in the LazyVim opts block at the bottom.
return {
  -- synthwave84: retro 80s sunset (hot pink / orange / purple)
  {
    "LunarVim/synthwave84.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Enable transparent background to show terminal sunset
      vim.g.synthwave_termcolors = 256
    end,
  },

  -- cyberdream: high-contrast neon cyberpunk with bold syntax
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      hide_fillchars = false,
      borderless_telescope = false,
    },
  },

  -- tokyonight: ships with LazyVim, neon-accented deep blues
  { "folke/tokyonight.nvim" },

  -- Set the active colorscheme here (change the string to switch)
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "synthwave84",
    },
  },
}
