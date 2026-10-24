-- Override LSP config to use Roslyn instead of omnisharp for C#
return {
  -- Use Roslyn LSP for C# (modern, officially supported by Microsoft)
  {
    "seblj/roslyn.nvim",
    ft = { "cs", "vb" },
    opts = {
      -- Roslyn only starts when in a C# project (has .sln or .csproj)
      -- No auto-start spam like omnisharp
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable omnisharp from lang.dotnet extra
        -- Using roslyn.nvim instead (better, modern alternative)
        omnisharp = false,
      },
    },
  },
}
