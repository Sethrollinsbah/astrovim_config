return {
  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      scope = { enabled = false },
      indent = { enabled = false },
      dashboard = {
        preset = {
          header = table.concat({
            "███████ █████ █████████ ██",
            "██      ██       ██     ██",
            "███████ ████████ ██ ██  ██",
            "     ██ ██       ██ ██████",
            "███████ ████████ ██ ██  ██",
            "",
            "██     ██ ██ ███    ███ ██",
            "██     ██    ████  ████ ██",
            "██     ██ ██ ██ ████ ██ ██",
            " ██   ██  ██ ██  ██  ██   ",
            "  █████   ██ ██      ██ ██",
          }, "\n"),
        },
      },
    },
  },


  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require("luasnip").setup(opts)
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      luasnip.filetype_extend("svelte", { "javascript", "typescript" })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require("nvim-autopairs").setup(opts)
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules({
        Rule("$", "$", { "tex", "latex" })
          -- don't add a pair if the next character is %
          :with_pair(cond.not_after_regex "%%")
          -- don't add a pair if  the previous character is xxx
          :with_pair(cond.not_before_regex("xxx", 3))
          -- don't move right when repeat character
          :with_move(cond.none())
          -- don't delete if the next character is xx
          :with_del(cond.not_after_regex "xx")
          -- disable adding a newline when you press <cr>
          :with_cr(cond.none()),
      })
    end,
  },
}
