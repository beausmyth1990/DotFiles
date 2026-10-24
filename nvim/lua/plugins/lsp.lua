-- Override LSP config to disable omnisharp unless in a C# project
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable omnisharp from lang.dotnet extra
        -- It tries to start even without C# files, causing errors
        omnisharp = false,
      },
    },
  },
}
