-- Standard LazySpec for TypeScript
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ts_ls = {
        init_options = {
          plugins = {
            {
              name = "typescript-svelte-plugin",
              location = vim.fn.stdpath "data" .. "/mason/packages/typescript-svelte-plugin/node_modules/typescript-svelte-plugin/lib/typescript-svelte-plugin.js",
            },
          },
        },
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      },
      eslint = {
        settings = {
          workingDirectories = { mode = "auto" },
        },
      },
    },
  },
}
