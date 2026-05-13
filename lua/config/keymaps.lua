-- General Keymaps
local map = vim.keymap.set

-- Standard Neovim keymaps
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })

-- Buffer navigation
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Escapes
map("i", "jk", "<ESC>", { desc = "Escape" })
map("i", "kj", "<ESC>", { desc = "Escape" })
map("t", "jk", [[<C-\><C-n>]], { desc = "Terminal normal mode" })
map("t", "kj", [[<C-\><C-n>]], { desc = "Terminal normal mode" })

-- Save in insert mode
map("i", "<C-s>", "<cmd>w<cr><ESC>", { desc = "Save" })

-- Telescope
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Live grep" })
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Find buffers" })
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Help tags" })
map("n", "<leader>fk", function() require("telescope.builtin").keymaps() end, { desc = "Find keymaps" })
map("n", "<leader>fd", function() require("telescope.builtin").diagnostics() end, { desc = "Find diagnostics" })

-- Modularized Menus (from lua/user/)
map("n", "<leader>mn", function() require("user.node_utils").run_node_menu() end, { desc = "Node.js Menu" })
map("n", "<leader>mm", function() require("user.make_utils").run_make_menu() end, { desc = "Make Menu" })
map("n", "<leader>mc", function() require("user.rust_utils").run_cargo_menu() end, { desc = "Cargo Menu" })

-- Workspace Navigation
map("n", "<leader>wn", function() require("user.workspace_utils").navigate_workspace_member "next" end, { desc = "Next workspace package" })
map("n", "<leader>wp", function() require("user.workspace_utils").navigate_workspace_member "prev" end, { desc = "Prev workspace package" })
map("n", "<leader>wo", function() require("user.workspace_utils").show_workspace_overview() end, { desc = "Workspace overview" })
map("n", "<leader>wi", function()
  local info = require("user.workspace_utils").get_workspace_info()
  vim.notify(string.format("Workspace: %s | Members: %d | Root: %s", info.is_workspace and "Yes" or "No", #info.members, vim.fn.fnamemodify(info.root, ":t")), vim.log.levels.INFO)
end, { desc = "Workspace info" })
