return {
    "nvim-mini/mini.nvim",
    version = "*",
    config = function()
        require("mini.ai").setup { n_lines = 500 }
        require("mini.surround").setup()
    end
}
