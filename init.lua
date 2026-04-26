-- Settings
vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.mouse = "a"
vim.o.wrap = true
vim.o.winborder = "single"
vim.o.guicursor = "a:block"
vim.o.clipboard = "unnamedplus"
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.swapfile = false
vim.o.undofile = true
vim.o.breakindent = true
vim.o.confirm = true
vim.o.scrolloff = 12

-- Format and Quickfix
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Telescope LSP
vim.keymap.set("n", "grd", "<cmd>Telescope lsp_definitions<CR>")
vim.keymap.set("n", "gri", "<cmd>Telescope lsp_implementations<CR>")
vim.keymap.set("n", "grr", "<cmd>Telescope lsp_references<CR>")

-- Telescope
vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<CR>")
vim.keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<CR>")
vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>si", "<cmd>Telescope git_files<CR>")
vim.keymap.set("n", "<leader>ss", "<cmd>Telescope builtin<CR>")
vim.keymap.set("n", "<leader>sw", "<cmd>Telescope grep_string<CR>")
vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics<CR>")
vim.keymap.set("n", "<leader>sr", "<cmd>Telescope resume<CR>")
vim.keymap.set("n", "<leader>s.", "<cmd>Telescope oldfiles<CR>")
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope buffers<CR>")

-- Force hjkl
vim.keymap.set("n", "<left>", "<cmd>echo \"Use h to move!!\"<CR>")
vim.keymap.set("n", "<right>", "<cmd>echo \"Use l to move!!\"<CR>")
vim.keymap.set("n", "<up>", "<cmd>echo \"Use k to move!!\"<CR>")
vim.keymap.set("n", "<down>", "<cmd>echo \"Use j to move!!\"<CR>")

-- Setup Lazy and Install Plugins
require("paulosergio.plugins")

-- Add Built-in Plugins
vim.cmd("packadd nvim.difftool")
vim.cmd("packadd nvim.undotree")

-- Enable LSP
vim.lsp.enable({ "lua_ls", "clangd", "ts_ls", "pyright", "roslyn_ls", "jdtls", "gopls" })

-- Autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("paulosergio-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang and vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf)
        end
    end,
})
