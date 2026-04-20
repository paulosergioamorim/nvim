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

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "<left>", "<cmd>echo \"Use h to move!!\"<CR>")
vim.keymap.set("n", "<right>", "<cmd>echo \"Use l to move!!\"<CR>")
vim.keymap.set("n", "<up>", "<cmd>echo \"Use k to move!!\"<CR>")
vim.keymap.set("n", "<down>", "<cmd>echo \"Use j to move!!\"<CR>")

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("paulosergio-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("paulosergio-lsp-attach", {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client:supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
        end

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "grn", vim.lsp.buf.rename)
        vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action)
        vim.keymap.set("n", "grr", builtin.lsp_references)
        vim.keymap.set("n", "gri", builtin.lsp_implementations)
        vim.keymap.set("n", "grd", builtin.lsp_definitions)
        vim.keymap.set("n", "grD", vim.lsp.buf.declaration)
        vim.keymap.set("n", "gO", builtin.lsp_document_symbols)
        vim.keymap.set("n", "gW", builtin.lsp_dynamic_workspace_symbols)
        vim.keymap.set("n", "grt", builtin.lsp_type_definitions)
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
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>sh", builtin.help_tags)
            vim.keymap.set("n", "<leader>sk", builtin.keymaps)
            vim.keymap.set("n", "<leader>sf", builtin.find_files)
            vim.keymap.set("n", "<leader>si", builtin.git_files)
            vim.keymap.set("n", "<leader>ss", builtin.builtin)
            vim.keymap.set("n", "<leader>sw", builtin.grep_string)
            vim.keymap.set("n", "<leader>sg", builtin.live_grep)
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics)
            vim.keymap.set("n", "<leader>sr", builtin.resume)
            vim.keymap.set("n", "<leader>s.", builtin.oldfiles)
            vim.keymap.set("n", "<leader><leader>", builtin.buffers)
        end
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

vim.cmd("colorscheme vague")
vim.cmd("hi statusline guibg=NONE")
vim.cmd("packadd nvim.undotree")

require("nvim-treesitter").install({ "c", "make", "bash", "html", "tsx", "typescript", "css", "python", "haskell", "xml",
    "markdown", "go" })

vim.lsp.enable({ "lua_ls", "clangd", "ts_ls", "pyright", "roslyn_ls", "jdtls", "gopls" })

require("vim._core.ui2").enable({})
