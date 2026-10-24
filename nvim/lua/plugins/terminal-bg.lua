-- Windows Terminal background control plugin
return {
  {
    "spiknyckel/windows-terminal-bg.nvim",
    config = function()
      local wtbg = require("wt-bg")
      
      -- Get Windows username from environment
      local win_user = "beaus"
      
      wtbg:setup({
        terminal_conf = "/mnt/c/Users/" .. win_user .. "/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json",
        bg_path = "/mnt/c/Users/" .. win_user .. "/Pictures/nvim_backgrounds/",
        windows_bg_path = "C:/Users/" .. win_user .. "/Pictures/nvim_backgrounds/",
      })
      
      -- Auto-set Tron background on startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(function()
            wtbg:set_background("tron_grid.jpg")
            wtbg:set_opacity(85)
          end, 100)
        end,
      })
      
      -- Keybindings to change background and opacity
      vim.keymap.set("n", "<leader>bg", function()
        local bg = vim.fn.input("Background: ")
        wtbg:set_background(bg)
      end, { desc = "Change terminal background" })
      
      vim.keymap.set("n", "<leader>bo", function()
        local opacity = vim.fn.input("Opacity (0-100): ")
        wtbg:set_opacity(tonumber(opacity) or 85)
      end, { desc = "Change terminal opacity" })
    end,
  },
}
