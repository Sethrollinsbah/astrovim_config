return {
  {
    "ahmedkhalf/project.nvim",
    opts = {
      -- disable project.nvim's default mappings if they exist
      -- or just ensure it doesn't conflict
      manual_mode = false,
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      -- We explicitly override the mapping here to be sure
      vim.keymap.set("n", "<leader>fp", function() 
        vim.lsp.buf.format { async = true } 
      end, { desc = "Format current file (Prettier/LSP)" })

      -- Move "find projects" to a different mapping
      vim.keymap.set("n", "<leader>fP", function() 
        require("telescope").load_extension("projects")
        require("telescope").extensions.projects.projects({})
      end, { desc = "Find projects" })
    end,
  },
}
