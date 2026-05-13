-- Standard LazySpec for System
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      bashls = { filetypes = { "sh", "bash" }, settings = { bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" } } },
      jsonls = { settings = { json = { validate = { enable = true }, format = { enable = true } } } },
      yamlls = { settings = { yaml = { keyOrdering = false, format = { enable = true }, hover = true, completion = true, validate = true, schemaStore = { enable = false, url = "" } } } },
    },
  },
}
