local map = vim.keymap.set
local lsp = vim.lsp

vim.diagnostic.config({ virtual_text = true, underline = true })
lsp.config("*", {
    on_attach = function(client, bufnr)
        lsp.semantic_tokens.enable(true)
        lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
        lsp.inlay_hint.enable(true)

        -- see [:help vim.lsp.*] for documentation on any of the below functions
        local opts = { buffer = bufnr }
        map("n", "gi", lsp.buf.implementation, opts)
        map("n", "gr", lsp.buf.references, opts)
        map("n", "gR", lsp.buf.rename, opts)
        map("n", "gu", function()
            lsp.buf.references({ includeDeclaration = false })
        end, opts) -- show usages only
        map("n", "<C-w>a", lsp.buf.code_action, opts)
        map("i", "<C-h>", lsp.buf.signature_help, opts)
    end,
    detached = true
}) -- consistent behaviours across language servers

-- server configs, usually just launch cmd, applicable filetypes and root marker
-- some specific language settings can be applied too
require("me.lsp.clangd")
require("me.lsp.jdtls")
require("me.lsp.pyright")
require("me.lsp.luals")
require("me.lsp.tsserver")

-- can be disabled/terminated by [:lsp disable/stop]
lsp.enable({ "clangd", "jdtls", "pyright", "luals", "tsserver" })

vim.api.nvim_create_autocmd("LspProgress", {
    group = vim.api.nvim_create_augroup("lsp_progress", { clear = true }),
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
    end -- report language server progress
})
