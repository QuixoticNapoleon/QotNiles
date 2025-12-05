return function()
  -- Enable true color
  vim.opt.termguicolors = true

  local ccc = require("ccc")
  local mapping = ccc.mapping

  ccc.setup({
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
    -- add other options here
  })
end

