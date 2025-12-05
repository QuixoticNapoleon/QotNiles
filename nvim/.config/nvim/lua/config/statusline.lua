-- ~/.config/nvim/lua/config/statusline.lua
return function()
  local colors = {
    fg     = '#8affff',
    bg     = '#003636',
    blue1  = '#00a8e6',
    blue2  = '#2dc5fc',
    green  = '#00e6a9',
    purple = '#d38cff',
    red1   = '#f07178',
    red2   = '#ff5370',
    yellow = '#ffcb6b',
  }

  local theal = {
    normal = {
      a = { fg = colors.bg, bg = colors.blue2, gui = 'bold' },
      b = { fg = colors.fg, bg = colors.bg },
      c = { fg = colors.fg, bg = colors.bg },
    },
    insert = {
      a = { fg = colors.bg, bg = colors.green, gui = 'bold' },
      b = { fg = colors.fg, bg = colors.bg },
    },
    visual = {
      a = { fg = colors.bg, bg = colors.purple, gui = 'bold' },
      b = { fg = colors.fg, bg = colors.bg },
    },
    replace = {
      a = { fg = colors.bg, bg = colors.red1, gui = 'bold' },
      b = { fg = colors.fg, bg = colors.bg },
    },
    command = {
      a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' },
      b = { fg = colors.fg, bg = colors.bg },
    },
    inactive = {
      a = { fg = colors.fg, bg = colors.bg, gui = 'bold' },
      b = { fg = colors.fg, bg = colors.bg },
      c = { fg = colors.fg, bg = colors.bg },
    },
  }

  require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = theal,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      always_divide_middle = true,
      globalstatus = false,
      refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
  }
end

