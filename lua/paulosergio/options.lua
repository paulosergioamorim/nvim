vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.winborder = "single"
vim.o.mouse = "a"
vim.o.wrap = true
vim.o.guicursor = "a:block"

vim.schedule(function()
    vim.o.clipboard = "unnamedplus"
end)

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.scrolloff = 10

vim.o.swapfile = false
vim.o.undofile = true
vim.o.breakindent = true
vim.o.confirm = true
