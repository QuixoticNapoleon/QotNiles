-- ~/.config/nvim/lua/config/treesitter.lua
return function()
  require("nvim-treesitter.configs").setup {
    ensure_installed = {
      "c",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
      "python",
      "javascript",
      "cpp",
      "rust",
      "haskell",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      disable = {"latex"},
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    -- incremental_selection = {
    --   enable = true,
    --   keymaps = {
    --     init_selection = "gnn",
    --     node_incremental = "grn",
    --     scope_incremental = "grc",
    --     node_decremental = "grm",
    --   },
    -- },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },
    fold = {
      enable = true,
    },

  }
  -- Add folding settings here
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.foldlevelstart = 99
  vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    if require("nvim-treesitter.parsers").has_parser() then
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
    else
      vim.opt.foldmethod = "indent"  -- or whatever you prefer
    end
  end,
})


end
