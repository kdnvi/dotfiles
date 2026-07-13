vim.diagnostic.config({ virtual_text = true, underline = true })
vim.lsp.config("*", {
    on_attach = function(client, bufnr)
        vim.lsp.semantic_tokens.enable(false)
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
        vim.lsp.inlay_hint.enable(true)

        -- see [:help vim.lsp.*] for documentation
        vim.keymap.set("n", "gru", function()
            vim.lsp.buf.references({ includeDeclaration = false })
        end, { buffer = bufnr }) -- show usages only
    end,
    detached = true
}) -- consistent behaviours across language servers

-- server configs, usually just launch cmd, applicable filetypes and root marker
-- some specific language settings can also be applied
require("me.lsp.clangd")
require("me.lsp.jdtls")
require("me.lsp.pyright")
require("me.lsp.tsserver")

-- can be disabled/terminated by [:lsp disable/stop] command
vim.lsp.enable({ "clangd", "jdtls", "pyright", "tsserver" })
