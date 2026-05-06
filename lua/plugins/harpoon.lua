return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
        end

        require("telescope.pickers").new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,
            }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
        }):find()
    end

    vim.keymap.set("n", "<leader>h", function() toggle_telescope(harpoon:list()) end,
        { desc = "Open harpoon window" })
  end,
  keys = {
    { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon Add File" },
    { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Toggle Menu" },
    { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon Select 1" },
    { "<C-j>", function() require("harpoon"):list():select(2) end, desc = "Harpoon Select 2" },
    { "<C-k>", function() require("harpoon"):list():select(3) end, desc = "Harpoon Select 3" },
    { "<C-l>", function() require("harpoon"):list():select(4) end, desc = "Harpoon Select 4" },
  },
}
