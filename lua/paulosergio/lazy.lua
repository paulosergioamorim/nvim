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
    require("paulosergio.plugins.blink"),
    require("paulosergio.plugins.fidget"),
    require("paulosergio.plugins.gitsigns"),
    require("paulosergio.plugins.mini"),
    require("paulosergio.plugins.nvim-lspconfig"),
    require("paulosergio.plugins.nvim-treesitter"),
    require("paulosergio.plugins.telescope"),
    require("paulosergio.plugins.vague"),
}

require("lazy").setup(plugins, opts)
