local map = vim.keymap.set
local lsp = vim.lsp

-- consistent behaviours across language servers
vim.diagnostic.config({ virtual_text = true, underline = true })
lsp.config("*", {
    on_attach = function(client, bufnr)
        lsp.semantic_tokens.enable(true)
        lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
        lsp.inlay_hint.enable(true)

        -- language server progress
        vim.api.nvim_create_autocmd("LspProgress", {
            buffer = bufnr,
            callback = function(e)
                local value = e.data.params.value or {}
                vim.api.nvim_echo({ { value.message or "done" } }, false, {
                    id = "lsp." .. e.data.client_id,
                    kind = "progress",
                    source = "vim.lsp",
                    title = value.title,
                    status = value.kind ~= "end" and "running" or "success",
                    percent = value.percentage,
                })
            end
        })

        -- see `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = bufnr }
        map("n", "gi", lsp.buf.implementation, opts)
        map("n", "gr", lsp.buf.references, opts)
        map("n", "gR", lsp.buf.rename, opts)
        map("n", "gu", function()
            lsp.buf.references({ includeDeclaration = false })
        end, opts) -- show usages only
        map("n", "<C-w>a", lsp.buf.code_action, opts)
        map("n", "<C-h>", lsp.buf.document_symbol, opts)
        map("i", "<C-k>", lsp.buf.signature_help, opts)
    end,
    detached = true
})

-- server configs, usually just launch cmd, applicable filetypes and root marker
-- some specific language settings can be applied too
require("me.lsp.clangd")
require("me.lsp.jdtls")
require("me.lsp.pyright")
require("me.lsp.luals")
require("me.lsp.tsserver")

-- can be disabled by `:lua vim.lsp.enable("tsserver", false)` for example
lsp.enable({ "clangd", "jdtls", "pyright", "luals", "tsserver" })
