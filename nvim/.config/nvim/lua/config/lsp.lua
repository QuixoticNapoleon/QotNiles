-- ~/.config/nvim/lua/config/lsp.lua
return function()
  -- Shared settings✖
  local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if cmp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  local on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    -- Normal mode: show diagnostics in a floating window
    vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { noremap=true, silent=true })

  end

  -- Server‑specific configurations
  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace   = { library = vim.api.nvim_get_runtime_file("", true) },
          telemetry   = { enable = false },
        },
      },
    },
    ts_ls = {},
    texlab = {
      settings = {
        texlab = {
          auxDirectory = "build",
          build = {
            executable = "latexmk",
            args       = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
            onSave     = true,
          },
          forwardSearch = {
            executable = "zathura",
            args       = { "--synctex-forward", "%l:1:%f", "%p" },
          },
        },
      },
    },
    clangd         = {},  -- C & C++
    pyright        = {},  -- Python
    rust_analyzer  = {},  -- Rust
    zls            = {},  -- Zig
    hls            = {},  -- Haskell
    jdtls          = {},  -- Java
    asm_lsp        = {},  -- Assembly (if you install it)
  }

  for name, cfg in pairs(servers) do
    -- Use the new api
    vim.lsp.config(name, {
      on_attach    = on_attach,
      capabilities = capabilities,
      settings     = cfg.settings,
      root_dir     = cfg.root_dir,  -- optional if you have special root logic
    })
    vim.lsp.enable(name)

    -- Diagnostic Icons
    vim.diagnostic.config({
      signs = {
        active = true,  -- enable signs
        text = {
          [vim.diagnostic.severity.ERROR] = "✖",
          [vim.diagnostic.severity.WARN]  = "",
          [vim.diagnostic.severity.INFO]  = "",
          [vim.diagnostic.severity.HINT]  = "",  -- lightbulb for hint
        },
      },
      -- virtual_text = {
      --   prefix = "●GAY●",
      -- },
      underline = true,
      severity_sort = true,
      virtual_text = true,  -- inline messages
      signs = true,         -- show signs in the gutter
      underline = true,     -- underline errors/warnings
      update_in_insert = false,
      -- severity_sort = true,
    })

    -- local signs = { Error = "✖", Warn = "", Hint = "", Info = "" }
    -- for type, icon in pairs(signs) do
    --   local hl = "DiagnosticSign" .. type
    --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    -- end

        -- Use Nerd Font symbols for diagnostics
    -- vim.fn.sign_define("DiagnosticSignError", {text = "✖", texthl = "DiagnosticError"}) -- x-mark
    -- vim.fn.sign_define("DiagnosticSignWarn",  {text = "", texthl = "DiagnosticWarn"})  -- warning triangle
    -- vim.fn.sign_define("DiagnosticSignInfo",  {text = "", texthl = "DiagnosticInfo"})  -- info circle
    -- vim.fn.sign_define("DiagnosticSignHint",  {text = "", texthl = "DiagnosticHint"})  -- lightbulb


    lualine_x = {
      {
        "diagnostics",
        sources = {"nvim_lsp"},
        sections = {"error", "warn", "info", "hint"},
        symbols = { error = " ", warn = " ", info = " ", hint = " " },
      }
    }

  end
end

