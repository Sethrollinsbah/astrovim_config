-- Standard LazySpec for Python
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
              diagnosticMode = "workspace",
              stubPath = vim.fn.stdpath "data" .. "/lazy/python-type-stubs",
            },
          },
        },
      },
    },
  },
}
