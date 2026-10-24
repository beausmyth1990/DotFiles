-- Delay render-markdown until treesitter parsers are ready
-- This prevents the first-launch race condition without blocking startup
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = function(_, opts)
      -- Add a check before enabling
      local parser_ok = pcall(vim.treesitter.language.add, "markdown")
      if not parser_ok then
        -- Parser not loaded yet, disable render-markdown for this session
        vim.notify("Treesitter parsers still compiling. Render-markdown disabled for this session.", vim.log.levels.WARN)
        return vim.tbl_extend("force", opts, { enabled = false })
      end
      return opts
    end,
  },
}
