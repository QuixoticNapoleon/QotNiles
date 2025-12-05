-- Keybindings

-- Swap Ctrl + C to Esc
-- vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<C-g>', '<Esc>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('i', '<Esc>', '<C-c>', { noremap = true, silent = true })


-- Leader Key
vim.g.mapleader = ' '

-- Tree
vim.api.nvim_set_keymap('n', '<leader>t', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
