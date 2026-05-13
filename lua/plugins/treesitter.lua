-- Standard Treesitter Configuration

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function(_, opts)
    -- Initialize treesitter
    -- Note: We use pcall because the API is currently in transition
    local ok, ts = pcall(require, "nvim-treesitter.configs")
    if ok then
      ts.setup(opts)
    else
      -- New API (v1.0+)
      require("nvim-treesitter").setup(opts)
    end
  end,
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "svelte",
      "astro",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "json",
      "yaml",
      "markdown",
      "markdown_inline",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
  },
}
