local M = {}

function M.run_make_menu()
  local has_toggleterm, toggleterm = pcall(require, "toggleterm")
  if not has_toggleterm then
    vim.notify("toggleterm.nvim is not installed or configured.", vim.log.levels.ERROR)
    return
  end

  local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then root = vim.fn.getcwd() end

  local makefile_path = vim.fn.filereadable(root .. "/Makefile") == 1 and (root .. "/Makefile")
    or (vim.fn.filereadable(root .. "/makefile") == 1 and (root .. "/makefile") or nil)

  if not makefile_path then
    vim.notify("No Makefile found in the project root.", vim.log.levels.WARN)
    return
  end

  local function get_make_targets()
    local targets = {}
    local file = io.open(makefile_path, "r")
    if not file then return targets end
    for line in file:lines() do
      local target, comment = line:match("^([a-zA-Z0-9_%-]+):.*%s*##%s*(.*)")
      if not target then target = line:match("^([a-zA-Z0-9_%-]+):") end
      if target and not target:find("^%.") then
        table.insert(targets, { name = target, comment = comment or "" })
      end
    end
    file:close()
    return targets
  end

  local targets = get_make_targets()
  if #targets == 0 then
    vim.notify("No targets found in the Makefile.", vim.log.levels.INFO)
    return
  end

  vim.ui.select(targets, {
    prompt = "🛠️  Select make command:",
    format_item = function(item)
      return (item.comment ~= "" and string.format("%-25s → %s", item.name, item.comment)) or item.name
    end,
  }, function(choice)
    if choice then
      require("toggleterm.terminal").Terminal:new({ cmd = "make " .. choice.name, direction = "tab", close_on_exit = false, on_open = function(_) vim.cmd("startinsert!") end }):toggle()
    end
  end)
end

return M
