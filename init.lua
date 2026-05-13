-- Standard Lazy.nvim init.lua

-- Add treesitter queries to runtime path early (for Neovim 0.12 compatibility)
local ts_runtime = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime"
if vim.fn.isdirectory(ts_runtime) == 1 then
  vim.opt.rtp:append(ts_runtime)
end

-- Load core configurations
require("config.options")
require("config.autocmds")
require("config.keymaps")

-- Setup lazy.nvim
require("config.lazy")
