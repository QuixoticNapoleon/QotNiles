-- Return a function so we can call it from Lazy.nvim
return function()
  local ls = require("luasnip")

  -- Load snippets from friendly-snippets
  require("luasnip.loaders.from_vscode").lazy_load()

  -- Example Lua snippets
  ls.add_snippets("lua", {
    ls.parser.parse_snippet("hi", "print('Hello, world!')"),
    ls.parser.parse_snippet("fn", "function ${1:name}(${2:args})\n\t$0\nend"),
  })

  local opts = { silent = true, noremap = true }

  -- Expand snippet or jump forward
  vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, opts)

  -- Jump backward
  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, opts)

  -- Change choice in choice node
  vim.keymap.set({ "i", "s" }, "<C-l>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end, opts)
end
