-- ~/.config/nvim/lua/config/indent.lua
return function()
    local ibl = require("ibl")
    local hooks = require("ibl.hooks")

    -- Define your highlight colors
    local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
    }

    -- Register hook to set highlights (resets on colorscheme change)
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end)

    -- Setup ibl with your highlights
    ibl.setup {
        indent = {
            highlight = highlight,
        },
	    exclude = {
	      filetypes = { "dashboard", "alpha", "help", "neo-tree", "NvimTree", "lazy" },
	      buftypes = { "nofile", "terminal" },  -- optional but useful
	    },
    }
end

