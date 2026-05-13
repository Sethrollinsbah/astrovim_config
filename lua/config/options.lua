-- General Neovim Options
local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.spell = false
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.timeoutlen = 300
opt.updatetime = 250
opt.completeopt = { "menu", "menuone", "noselect" }
opt.ignorecase = true
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","
