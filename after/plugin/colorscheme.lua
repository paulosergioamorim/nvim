-- Colorscheme and UI2
vim.cmd("colorscheme vague")
vim.cmd("hi statusline guibg=NONE")
require("vim._core.ui2").enable({})

-- Fix Float Window Color
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "Normal" })
vim.api.nvim_set_hl(0, "BlinkCmpKind", { link = "Normal" })
