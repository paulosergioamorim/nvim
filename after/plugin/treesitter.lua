local parsers = {
    -- Default Parsers
    "c", "lua", "markdown", "vimdoc",
    -- Custom Parsers
    "xml", "html", "css", "tsx", "typescript",
    "bash", "python", "haskell", "go", "c_sharp",
}

-- Install Treesitter Parsers
require("nvim-treesitter").install(parsers)
