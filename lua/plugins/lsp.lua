return {
  -- LSP Configuration & Plugins
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      { "j-hui/fidget.nvim", opts = {} },
      "folke/neodev.nvim",
    },
    -- opts will be merged from language-specific files
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        -- Add other servers here or in language-specific files
        svelte = {},
        html = {},
        cssls = {},
        ts_ls = {},
        pyright = {},
      },
    },
    config = function(_, opts)
      require("neodev").setup()

      -- 1. Define global capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

      -- 2. Set global defaults for all servers
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- 3. Mason-lspconfig setup
      local servers = vim.tbl_keys(opts.servers or {})
      require("mason-lspconfig").setup {
        ensure_installed = servers,
      }

      -- 4. Apply server-specific configs and enable them
      -- We iterate over all servers defined in opts.servers
      for server_name, server_opts in pairs(opts.servers or {}) do
        -- Skip servers handled by other plugins
        if server_name ~= "rust_analyzer" then
          -- Set the config using the modern Neovim API
          vim.lsp.config(server_name, server_opts)
          -- Enable the server
          vim.lsp.enable(server_name)
        end
      end
    end,
  },
}
