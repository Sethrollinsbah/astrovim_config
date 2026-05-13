local M = {}

function M.run_node_menu()
  -- Ensure toggleterm is loaded and available
  local has_toggleterm, toggleterm = pcall(require, "toggleterm")
  if not has_toggleterm then
    vim.notify("toggleterm.nvim is not installed or configured.", vim.log.levels.ERROR)
    return
  end

  -- Check if package.json exists
  local function has_package_json()
    local file = io.open("package.json", "r")
    if file then
      file:close()
      return true
    end
    return false
  end

  if not has_package_json() then
    vim.notify("No package.json found in current directory.", vim.log.levels.WARN)
    return
  end

  -- Parse package.json to detect project type and available scripts
  local function get_project_info()
    local file = io.open("package.json", "r")
    if not file then return nil end
    
    local content = file:read("*a")
    file:close()
    
    local ok, package_data = pcall(vim.fn.json_decode, content)
    if not ok or not package_data then return nil end
    
    return package_data
  end

  -- Detect package manager
  local function detect_package_manager()
    local yarn_lock = io.open("yarn.lock", "r")
    local pnpm_lock = io.open("pnpm-lock.yaml", "r")
    local bun_lock = io.open("bun.lockb", "r")
    
    if bun_lock then
      bun_lock:close()
      return "bun"
    elseif pnpm_lock then
      pnpm_lock:close()
      return "pnpm"
    elseif yarn_lock then
      yarn_lock:close()
      return "yarn"
    else
      return "npm"
    end
  end

  -- Detect project type from dependencies
  local function detect_project_type(package_data)
    local deps = {}
    if package_data.dependencies then
      for dep, _ in pairs(package_data.dependencies) do deps[dep] = true end
    end
    if package_data.devDependencies then
      for dep, _ in pairs(package_data.devDependencies) do deps[dep] = true end
    end

    local types = {}
    if deps.react or deps["@types/react"] then table.insert(types, "React") end
    if deps.next then table.insert(types, "Next.js") end
    if deps.vue or deps["@vue/cli-service"] then table.insert(types, "Vue.js") end
    if deps["@angular/core"] then table.insert(types, "Angular") end
    if deps.svelte then table.insert(types, "Svelte") end
    if deps.express then table.insert(types, "Express") end
    if deps.fastify then table.insert(types, "Fastify") end
    if deps.electron then table.insert(types, "Electron") end
    if deps.typescript or deps["@types/node"] then table.insert(types, "TypeScript") end
    if deps.jest then table.insert(types, "Jest") end
    if deps.vitest then table.insert(types, "Vitest") end
    if deps.mocha then table.insert(types, "Mocha") end
    if deps.webpack then table.insert(types, "Webpack") end
    if deps.vite then table.insert(types, "Vite") end
    if deps.parcel then table.insert(types, "Parcel") end

    return types
  end

  local package_data = get_project_info()
  if not package_data then
    vim.notify("Failed to parse package.json", vim.log.levels.ERROR)
    return
  end

  local package_manager = detect_package_manager()
  local project_types = detect_project_type(package_data)
  local scripts = package_data.scripts or {}

  local function build_command(cmd) return package_manager .. " " .. cmd end
  local function build_run_command(script) return package_manager .. " run " .. script end

  local commands = {
    { "📦 Install Dependencies", build_command("install"), "pkg" },
    { "🔄 Update Dependencies", build_command("update"), "pkg" },
  }

  if package_manager == "npm" then
    table.insert(commands, { "📋 List Dependencies", "npm list", "pkg" })
    table.insert(commands, { "🔍 Outdated Packages", "npm outdated", "pkg" })
  elseif package_manager == "yarn" then
    table.insert(commands, { "📋 List Dependencies", "yarn list", "pkg" })
    table.insert(commands, { "🔍 Outdated Packages", "yarn outdated", "pkg" })
    table.insert(commands, { "🧹 Clean Cache", "yarn cache clean", "pkg" })
  elseif package_manager == "pnpm" then
    table.insert(commands, { "📋 List Dependencies", "pnpm list", "pkg" })
    table.insert(commands, { "🔍 Outdated Packages", "pnpm outdated", "pkg" })
    table.insert(commands, { "🧹 Store Prune", "pnpm store prune", "pkg" })
  elseif package_manager == "bun" then
    table.insert(commands, { "📋 List Dependencies", "bun pm ls", "pkg" })
    table.insert(commands, { "🧹 Clean Cache", "bun pm cache rm", "pkg" })
  end

  local function categorize_script(script_name)
    if script_name:match("^dev") or script_name == "start" or script_name:match("serve") then
      return "dev", "🚀"
    elseif script_name:match("build") or script_name:match("compile") then
      return "build", "🔨"
    elseif script_name:match("test") then
      return "test", "🧪"
    elseif script_name:match("lint") or script_name:match("format") or script_name:match("prettier") or script_name:match("eslint") then
      return "quality", "✨"
    elseif script_name:match("type") and script_name:match("check") then
      return "quality", "🔍"
    elseif script_name:match("preview") or script_name:match("storybook") then
      return "preview", "👀"
    elseif script_name:match("deploy") or script_name:match("publish") then
      return "deploy", "🚀"
    else
      return "script", "📜"
    end
  end

  local script_names = {}
  for script_name, _ in pairs(scripts) do table.insert(script_names, script_name) end
  table.sort(script_names)

  for _, script_name in ipairs(script_names) do
    local category, icon = categorize_script(script_name)
    local display_name = string.format("%s %s", icon, script_name)
    table.insert(commands, { display_name, build_run_command(script_name), category })
  end

  local project_info = #project_types > 0 and " (" .. table.concat(project_types, ", ") .. ")" or ""

  vim.ui.select(commands, {
    prompt = "📦 Select " .. package_manager .. " command" .. project_info .. ":",
    format_item = function(item)
      local category_icons = { pkg = "📦 ", dev = "🚀 ", build = "🔨 ", test = "🧪 ", quality = "✨ ", preview = "👀 ", deploy = "🚀 ", script = "📜 ", framework = "🎯 ", utility = "🛠️  ", custom = "✏️ " }
      return (item[1]:match("^[%z\1-\127]") and item[1]) or ((category_icons[item[3]] or "• ") .. item[1])
    end,
  }, function(choice)
    if choice then
      local command_to_run = choice[2]
      if command_to_run == "custom" then
        vim.ui.input({ prompt = "Enter custom " .. package_manager .. " command: ", default = package_manager .. " " }, function(custom_cmd)
          if custom_cmd and custom_cmd ~= "" then
            local Terminal = require("toggleterm.terminal").Terminal
            Terminal:new({ cmd = custom_cmd, direction = "tab", close_on_exit = false, on_open = function(_) vim.cmd("startinsert!") end }):toggle()
          end
        end)
      else
        local Terminal = require("toggleterm.terminal").Terminal
        Terminal:new({ cmd = command_to_run, direction = "tab", close_on_exit = false, on_open = function(_) vim.cmd("startinsert!") end }):toggle()
      end
    end
  end)
end

return M
