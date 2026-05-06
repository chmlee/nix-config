local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config("basedpyright", {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", ".git", "flake.nix" },
  capabilities = capabilities,
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        pythonPath = vim.fn.exepath("python3"),
        autoImportCompletions = true,
        extraPaths = { "./" },
      },
    },
  },
})
vim.lsp.enable("basedpyright")



vim.opt.completeopt = { "menu", "menuone", "noselect" }


vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = { enable = false },
    },
  },
})
vim.lsp.enable("lua_ls")





vim.lsp.config("r_language_server", {
  cmd = { "R", "--slave", "-e", "languageserver::run()" },
  filetypes = { "r", "rmd", "quarto" },
})
vim.lsp.enable("r_language_server")

vim.lsp.enable("ts_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("nil_ls")






-- nice borders for all floating windows
vim.o.winborder = "rounded"
vim.opt.completeopt = { "menu", "menuone", "popup", "noinsert" }

vim.diagnostic.config({
  float = { border = "rounded" },
})



-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
  },
})

-- LSP keymaps when a server attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = buf }

    -- auto completion popup
    if client then
      vim.lsp.completion.enable(true, client.id, buf, {
        autotrigger = true,
      })
    end

    -- navigation
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

    -- info
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", function()
      vim.lsp.buf.signature_help({ border = "rounded" })
    end, { buffer = buf })

    -- actions
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    -- diagnostics
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

    -- formatting
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, opts)

    -- inlay hints
    -- vim.keymap.set("n", "<leader>uh", function()
    --   local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
    --   vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
    -- end, { desc = "Toggle inlay hints" })

    -- native completion
    vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"
  end,
})
