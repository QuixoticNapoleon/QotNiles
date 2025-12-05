--  ░██████╗░██╗░░░██╗██╗██╗░░██╗░█████╗░████████╗██╗░█████╗░░░░░░░███╗░░██╗██╗░░░██╗██╗███╗░░░███╗
--  ██╔═══██╗██║░░░██║██║╚██╗██╔╝██╔══██╗╚══██╔══╝██║██╔══██╗░░░░░░████╗░██║██║░░░██║██║████╗░████║
--  ██║██╗██║██║░░░██║██║░╚███╔╝░██║░░██║░░░██║░░░██║██║░░╚═╝█████╗██╔██╗██║╚██╗░██╔╝██║██╔████╔██║
--  ╚██████╔╝██║░░░██║██║░██╔██╗░██║░░██║░░░██║░░░██║██║░░██╗╚════╝██║╚████║░╚████╔╝░██║██║╚██╔╝██║
--  ░╚═██╔═╝░╚██████╔╝██║██╔╝╚██╗╚█████╔╝░░░██║░░░██║╚█████╔╝░░░░░░██║░╚███║░░╚██╔╝░░██║██║░╚═╝░██║
--  ░░░╚═╝░░░░╚═════╝░╚═╝╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░╚═╝░╚════╝░░░░░░░╚═╝░░╚══╝░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝
--
--  By QuixoticNapoleon

--------------------------------------------------------
-- 🪶 Plugins
--------------------------------------------------------

require("config.lazy")

--------------------------------------------------------
-- 🪶 Theme
--------------------------------------------------------

local dark_teal = "#003636"
vim.cmd("colorscheme terafox")

--------------------------------------------------------
-- 🪶 Basic Settings
--------------------------------------------------------

-- List Chars
vim.o.list = true
vim.opt.listchars = {
	-- tab = "»·",
	tab = "│»",
	space = "·",
	trail = "·",
	eol = "↲",
	extends = "›",
	precedes = "‹",
	nbsp = "␣",
}

-- Enable wrapping
vim.opt.wrap = true

-- Break lines at word boundaries
vim.opt.linebreak = true

-- Prefix shown on wrapped lines
vim.opt.showbreak = "↳ "

-- Indent wrapped lines to match indentation
vim.opt.breakindent = true

-- (Optional) fine-tune breakindent behavior
-- vim.opt.breakindentopt = "shift:2"

-- Line Numbers
vim.wo.number = true
vim.wo.relativenumber = true


-- Change the color of the line numbers
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#74c4c4', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#74c4c4', bg = 'NONE' })


-- Tab Spaces
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
-- vim.cmd("set expandtab")
vim.cmd("set noexpandtab")
vim.cmd("set smarttab")

-- Indentation Options
vim.opt.indentkeys:remove(":")
vim.opt.smartindent = true



--------------------------------------------------------
-- 🪶 Basic Keybindings
--------------------------------------------------------

-- Leader Key
vim.g.mapleader = ' '

-- Tree
vim.api.nvim_set_keymap('n', '<leader>t', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- ~/.config/nvim/lua/keymaps.lua
vim.keymap.set('n', '<Space>;', function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- save cursor
    local line = vim.api.nvim_get_current_line()

    -- Only add semicolon if it doesn't exist
    if not line:match(";$") then
        vim.api.nvim_set_current_line(line .. ";")
    end

    -- Restore cursor
    vim.api.nvim_win_set_cursor(0, {row, col})
end, { noremap = true, silent = true })


-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

--------------------------------------------------------
-- 🪶 GUI and Colour Configuration
--------------------------------------------------------

-- Colors
vim.opt.termguicolors = true
vim.opt.background = "dark"  -- or "light" depending on theme

-- Remove Vim Background
vim.api.nvim_set_hl(0, "Normal", { ctermbg = "none", bg = "none" })

-- Colors (Foreground and Background)
-- Neovide uses Neovim's colorscheme, so we’ll override via highlight groups
-- vim.api.nvim_set_hl(0, "Normal", { fg = "#8affff", bg = "#003636" })
vim.api.nvim_set_hl(0, "Normal", { fg = "#8affff", bg = "none", ctermbg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#8affff", bg = "#003636" })


-- Set font and size
-- vim.o.guifont = "JetBrainsMono Nerd Font:h14"
-- vim.o.guifont = "Source Code Pro:h10.5"
vim.o.guifont = "JetBrainsMono Nerd Font:h10.5"


-- General Neovim GUI
vim.cmd([[
	highlight Normal guibg=NONE ctermbg=NONE
	highlight NormalNC guibg=NONE ctermbg=NONE
	highlight LineNr guibg=NONE
	highlight SignColumn guibg=NONE
	highlight WinSeparator guifg=#74c4c4 guibg=NONE
	
	
	highlight Pmenu guibg=NONE
	highlight PmenuSel guifg=#FFFFFF guibg=#008282
	highlight FloatBorder guifg=#74c4c4
	
	highlight NvimTreeNormal guibg=NONE
	highlight NvimTreeNormalFloat guibg=NONE
	highlight NvimTreeCursorLine guibg=#395e5e
	
	highlight Visual guibg=#395e5e

	highlight EndOfBuffer guifg=#016868
	highlight SpecialKey guifg=#016868
	highlight Trailing guifg=#016868
	highlight Whitespace guifg=#016868
	highlight NonText guifg=#016868
]])


-- For Tabs and Folds
vim.cmd [[
	highlight BufferCurrent guifg=#FFFFFF guibg=#003636
	highlight BufferVisible guifg=#CCCCCC guibg=#003636
	highlight BufferInactive guifg=#888888 guibg=#003636
	
	highlight BufferCurrentMod guifg=#fce094 guibg=#003636
	highlight BufferVisibleMod guibg=#003636
	highlight BufferInactiveMod guibg=#003636
	
	highlight BufferDefaultCurrent guifg=#FFFFFF guibg=#003636
	highlight BufferDefaultVisible guifg=#CCCCCC guibg=#003636
	highlight BufferDefaultInactive guifg=#888888 guibg=#003636
	
	highlight BufferInactiveSign guifg=#8affff  guibg=#003636
	highlight BufferVisibleSign  guifg=#8affff  guibg=#003636
	highlight BufferCurrentSign  guifg=#8affff  guibg=#003636
	
	highlight BufferDefaultInactiveSign guifg=#8affff  guibg=#003636
	highlight BufferDefaultVisibleSign  guifg=#8affff  guibg=#003636
	highlight BufferDefaultCurrentSign  guifg=#8affff  guibg=#003636
	
	highlight BufferDefaultInactiveIcon guifg=#8affff  guibg=#003636
	highlight BufferDefaultVisibleIcon  guifg=#8affff  guibg=#003636
	highlight BufferDefaultCurrentIcon  guifg=#8affff  guibg=#003636
	
	highlight BufferInactiveIcon guifg=#8affff  guibg=#003636
	highlight BufferVisibleIcon  guifg=#8affff  guibg=#003636
	highlight BufferCurrentIcon  guifg=#8affff  guibg=#003636
	
	highlight BufferTabpageFill guibg=#003636
	
	highlight Folded guifg=#74c4c4  guibg=#003636
	highlight FoldColumn guifg=#74c4c4  guibg=#003636
]]
