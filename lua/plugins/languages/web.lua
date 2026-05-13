-- Standard LazySpec for Web
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      html = {
        filetypes = { "html", "templ" },
        settings = { html = { format = { templating = true, wrapLineLength = 120, wrapAttributes = "auto" }, hover = { documentation = true, references = true } } },
      },
      cssls = {
        settings = { css = { validate = true, lint = { unknownAtRules = "ignore" } }, scss = { validate = true, lint = { unknownAtRules = "ignore" } }, less = { validate = true, lint = { unknownAtRules = "ignore" } } },
      },
      svelte = {
        settings = {
          svelte = {
            plugin = {
              html = { completions = { enable = true, emmet = true }, hover = { enable = true } },
              svelte = { completions = { enable = true }, hover = { enable = true } },
              css = { completions = { enable = true, emmet = true }, hover = { enable = true } },
              typescript = { completions = { enable = true }, hover = { enable = true }, diagnostics = { enable = true } },
            },
          },
        },
      },
      emmet_ls = {
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte", "vue", "astro" },
      },
      astrols = {},
      volar = {
        filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
        init_options = { vue = { hybridMode = false } },
      },
      tailwindcss = {
        filetypes = { "html", "css", "javascript", "typescript", "svelte", "vue", "jsx", "tsx" },
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = { "tw`([^`]*)", 'tw="([^"]*)', 'tw={"([^"}]*)', "tw\\.\\w+`([^`]*)", "tw\\(.*?\\)`([^`]*)", },
            },
          },
        },
      },
    },
  },
}
