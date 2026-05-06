-- lua/plugins/languages/markdown.lua
-- Markdown language server configuration

return {
  servers = {
    marksman = {},
  },

  -- Markdown-specific on_attach
  on_attach = function(client, bufnr)
    -- Markdown-specific keymaps or logic
  end,
}
