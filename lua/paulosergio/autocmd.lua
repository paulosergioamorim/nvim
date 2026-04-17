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

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
        end

        if client:supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format" })
        end

        local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
        end

        map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

        local builtin = require("telescope.builtin")

        map("grr", builtin.lsp_references, "[G]oto [R]eferences")
        map("gri", builtin.lsp_implementations, "[G]oto [I]mplementation")
        map("grd", builtin.lsp_definitions, "[G]oto [D]efinition")
        map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("gO", builtin.lsp_document_symbols, "Open Document Symbols")
        map("gW", builtin.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
        map("grt", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "*" },
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang and vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf)
        end
    end,
})
