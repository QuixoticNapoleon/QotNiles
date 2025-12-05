return function()
  -- Use Zathura as the PDF viewer
  vim.g.vimtex_view_method = "zathura"

  -- Compile using latexmk automatically
  vim.g.vimtex_compiler_method = "latexmk"
  vim.g.vimtex_compiler_latexmk = {
    build_dir = "build",       -- Keep files in a separate folder
    callback = 1,
    continuous = 1,            -- Automatically recompile on save
    executable = "latexmk",
    options = {
      "-pdf",
      "-interaction=nonstopmode",
      "-synctex=1",
    },
  }

  -- Optional: disable conceal for clearer LaTeX text
  vim.g.vimtex_syntax_conceal = {
    accents = 0,
    ligatures = 0,
    cites = 0,
    fancy = 0,
    spacing = 0,
    greek = 0,
    math_delimiters = 0,
    math_super_sub = 0,
  }
end
