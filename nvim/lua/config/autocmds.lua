-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Highlight redundant whitespace (trailing spaces) on cursor line in insert mode

-- Define the highlight group
local function set_whitespace_hl()
  vim.api.nvim_set_hl(0, "RedundantWhitespace", { 
    fg = "#000000",  -- Black text
    bg = "#66ff66",  -- Lighter neon green background
    bold = true,
  })
end

-- Set it initially
set_whitespace_hl()

-- Re-apply after colorscheme changes and on every insert enter
vim.api.nvim_create_autocmd({ "ColorScheme", "InsertEnter" }, {
  callback = set_whitespace_hl,
})

-- Track match IDs per window
local match_ids = {}

-- Highlight redundant whitespace on current line (insert mode only)
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  callback = function()
    local win_id = vim.api.nvim_get_current_win()
    
    -- Clear all previous matches for this window (starting fresh insert session)
    if match_ids[win_id] then
      for _, id in ipairs(match_ids[win_id]) do
        pcall(vim.fn.matchdelete, id)
      end
    end
    match_ids[win_id] = {}
    
    -- Add match for starting line (ALL whitespace)
    local line = vim.fn.line(".")
    local pattern = [[\%]] .. line .. [[l\s]]
    table.insert(match_ids[win_id], vim.fn.matchadd("RedundantWhitespace", pattern))
  end,
})

vim.api.nvim_create_autocmd({ "CursorMovedI" }, {
  callback = function()
    local win_id = vim.api.nvim_get_current_win()
    local line = vim.fn.line(".")
    
    -- Add match for new line (ALL whitespace)
    local pattern = [[\%]] .. line .. [[l\s]]
    table.insert(match_ids[win_id], vim.fn.matchadd("RedundantWhitespace", pattern))
  end,
})

-- Clean up when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    local win_id = vim.api.nvim_get_current_win()
    if match_ids[win_id] then
      for _, id in ipairs(match_ids[win_id]) do
        pcall(vim.fn.matchdelete, id)
      end
      match_ids[win_id] = nil
    end
  end,
})
