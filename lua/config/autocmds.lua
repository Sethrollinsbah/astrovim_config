-- General Autocommands
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Rust workspace detection
local rust_group = augroup("RustWorkspace", { clear = true })
autocmd({ "BufEnter", "BufWinEnter" }, {
  group = rust_group,
  pattern = "*.rs",
  callback = function()
    local workspace_info = require("user.workspace_utils").get_workspace_info()
    if workspace_info.is_workspace then
      vim.opt_local.path:append(workspace_info.root .. "/*/src")
      vim.opt_local.suffixesadd:append ".rs"
      vim.b.rust_workspace = true
      if not vim.g.rust_workspace_notified then
        vim.notify("🦀 Rust workspace detected (" .. #workspace_info.members .. " members)", vim.log.levels.INFO)
        vim.g.rust_workspace_notified = true
      end
    end
  end,
})

-- Force Svelte filetype detection
vim.filetype.add({
  extension = {
    svelte = "svelte",
  },
})

-- Force Treesitter for Svelte
autocmd({ "FileType" }, {
  pattern = "svelte",
  callback = function(args)
    pcall(vim.treesitter.start, args.buf, "svelte")
  end,
})

-- Global LSP Attach logic
autocmd("LspAttach", {
  group = augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- Set keymaps
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gr", vim.lsp.buf.references, "Go to references")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<leader>la", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>D", vim.diagnostic.open_float, "Show line diagnostics")

    -- Format on save if enabled
    if client.supports_method("textDocument/formatting") then
      autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
        end,
      })
    end

    -- Refresh codelens
    if client.supports_method("textDocument/codeLens") then
      vim.lsp.codelens.refresh({ bufnr = bufnr })
      autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        buffer = bufnr,
        callback = function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end,
      })
    end

    -- TypeScript specific mappings
    if client.name == "ts_ls" then
      map("n", "<leader>to", function()
        vim.lsp.buf.execute_command({
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
        })
      end, "Organize imports")

      map("n", "<leader>tr", function()
        vim.lsp.buf.execute_command({
          command = "_typescript.removeUnused",
          arguments = { vim.api.nvim_buf_get_name(0) },
        })
      end, "Remove unused imports")
    end
  end,
})
