local M = {}

function M.run_cargo_menu()
  local has_toggleterm, toggleterm = pcall(require, "toggleterm")
  if not has_toggleterm then
    vim.notify("toggleterm.nvim is not installed or configured.", vim.log.levels.ERROR)
    return
  end

  local function is_workspace()
    local handle = io.popen("cargo metadata --format-version 1 --no-deps 2>/dev/null")
    if not handle then return false end
    local output = handle:read("*a")
    handle:close()
    if not output or output == "" then return false end
    local ok, result = pcall(vim.fn.json_decode, output)
    return ok and result and result.packages and #result.packages > 1
  end

  local is_ws = is_workspace()

  local commands = {
    { "🔍 Check", "cargo check" .. (is_ws and " --workspace" or ""), "basic" },
    { "🔨 Build", "cargo build" .. (is_ws and " --workspace" or ""), "basic" },
    { "🧪 Test", "cargo test" .. (is_ws and " --workspace" or ""), "basic" },
    { "📎 Clippy", "cargo clippy" .. (is_ws and " --workspace" or "") .. " -- -D warnings", "basic" },
    { "📚 Generate Docs", "cargo doc --open" .. (is_ws and " --workspace" or ""), "docs" },
    { "🎨 Format Code", "cargo fmt" .. (is_ws and " --all" or ""), "docs" },
    { "⚡ Bench", "cargo bench" .. (is_ws and " --workspace" or ""), "perf" },
    { "✏️  Custom Command...", "custom", "custom" },
  }

  vim.ui.select(commands, {
    prompt = "🦀 Select cargo command" .. (is_ws and " (workspace detected)" or "") .. ":",
    format_item = function(item)
      local icons = { basic = "⚙️ ", docs = "📚 ", perf = "⚡ ", utility = "🛠️  ", custom = "✏️ ", workspace = "🏢 " }
      return (icons[item[3]] or "• ") .. item[1]
    end,
  }, function(choice)
    if choice then
      local cmd = choice[2]
      if cmd == "custom" then
        vim.ui.input({ prompt = "Enter custom cargo command: ", default = "cargo " }, function(input)
          if input and input ~= "" then
            require("toggleterm.terminal").Terminal:new({ cmd = input, direction = "tab", close_on_exit = false, on_open = function(_) vim.cmd("startinsert!") end }):toggle()
          end
        end)
      else
        require("toggleterm.terminal").Terminal:new({ cmd = cmd, direction = "tab", close_on_exit = false, on_open = function(_) vim.cmd("startinsert!") end }):toggle()
      end
    end
  end)
end

return M
