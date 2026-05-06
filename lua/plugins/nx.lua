return {
  "Equilibris/nx.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    -- nx.nvim configuration options
    nx_cmd_root = "npx nx", -- The command to run nx
  },
  keys = {
    { "<leader>nx", "<cmd>Telescope nx actions<CR>", desc = "Nx Actions" },
    { "<leader>nG", "<cmd>Telescope nx generators<CR>", desc = "Nx Generators" },
  },
}
