return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local grammars = { "c", "make", "bash", "html", "tsx", "typescript", "css", "python", "haskell", "xml",
            "markdown", "go" }

        require("nvim-treesitter").install(grammars)
    end
}
