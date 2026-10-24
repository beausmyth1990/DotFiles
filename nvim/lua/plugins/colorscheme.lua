-- Tron-style neon blue colorschemes
return {
  -- tokyonight: electric blue/cyan neon (Tron aesthetic)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm", -- storm has the electric blue look
      transparent = true,
      terminal_colors = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  -- cyberdream: high-contrast neon cyberpunk (backup option)
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

  -- synthwave84: retro 80s sunset (hot pink / orange / purple)
  {
    "LunarVim/synthwave84.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.synthwave_termcolors = 256
      -- Enable transparency after loading the colorscheme
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "synthwave84",
        callback = function()
          vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
          vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
        end,
      })
    end,
  },

  -- Set the active colorscheme here (change the string to switch)
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "synthwave84",
    },
  },
}
