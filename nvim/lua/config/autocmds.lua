-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Highlight redundant whitespace (trailing, or spaces before a tab) on the
-- cursor's current line only. Credit: technique from Dave Eddy's vimrc (ysap)
local redundant_ws = vim.api.nvim_create_augroup("RedundantWhitespace", { clear = true })

vim.api.nvim_set_hl(0, "RedundantWhitespace", { bg = "#c8a165" }) -- light brown

local match_id = nil

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinEnter" }, {
  group = redundant_ws,
  callback = function()
    -- clear previous match
    if match_id then
      pcall(vim.fn.matchdelete, match_id)
      match_id = nil
    end
    -- match trailing whitespace / spaces-before-tab, scoped to current line
    local line = vim.fn.line(".")
    match_id = vim.fn.matchadd("RedundantWhitespace", [[\%]] .. line .. [[l\(\s\+$\| \+\ze\t\)]])
  end,
})
