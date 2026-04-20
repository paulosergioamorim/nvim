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

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) or vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
local plugins = {
    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "1.*",
        opts = {
            keymap = { preset = "default" },
            appearance = {
                nerd_font_variant = "mono"
            },
            completion = {
                list = {
                    selection = {
                        auto_insert = false,
                        preselect = false,
                    }
                },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
    },
    { "nvim-mini/mini.ai",       opts = {} },
    { "nvim-mini/mini.surround", opts = {} },
    { "neovim/nvim-lspconfig" },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
    },
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- optional but recommended
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        opts = {}
    },
    {
        "vague-theme/vague.nvim",
        lazy = false,    -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other plugins
        opts = {
            -- NOTE: you do not need to call setup if you don"t want to.
            bold = false,
            italic = false,
        }
    },
}

require("lazy").setup(plugins, opts)

-- Colorscheme and UI2
vim.cmd("colorscheme vague")
vim.cmd("hi statusline guibg=NONE")
require("vim._core.ui2").enable({})
-- Fix Float Window Color
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "Normal" })
vim.api.nvim_set_hl(0, "BlinkCmpKind", { link = "Normal" })

vim.cmd("packadd nvim.undotree")

vim.lsp.enable({ "lua_ls", "clangd", "ts_ls", "pyright", "roslyn_ls", "jdtls", "gopls" })

require("nvim-treesitter").install({ "c", "make", "bash", "html", "tsx", "typescript", "css", "python", "haskell", "xml",
    "markdown", "go" })

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
