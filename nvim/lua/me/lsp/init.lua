vim.diagnostic.config({ virtual_text = true, underline = true })
vim.lsp.config("*", {
    on_attach = function(client, bufnr)
        vim.lsp.semantic_tokens.enable(false)
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
        vim.lsp.inlay_hint.enable(true)

        -- see [:help vim.lsp.*] for documentation on any of the below functions
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gR", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gu", function()
            lsp.buf.references({ includeDeclaration = false })
        end, opts) -- show usages only
        vim.keymap.set("n", "<C-w>a", vim.lsp.buf.code_action, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    end,
    detached = true
}) -- consistent behaviours across language servers

vim.api.nvim_create_autocmd("LspProgress", {
    group = vim.api.nvim_create_augroup("lsp_progress", { clear = true }),
    callback = function(e)
        if vim.fn.mode() == "i" then return end
        local value = e.data.params.value
        vim.api.nvim_echo({ { value.message or "done" } }, false, {
            id = "lsp." .. e.data.client_id,
            kind = "progress",
            source = "vim.lsp",
            title = value.title,
            status = value.kind ~= "end" and "running" or "success",
            percent = value.percentage,
        })
    end -- language server progress
})

-- server configs, usually just launch cmd, applicable filetypes and root marker
-- some specific language settings can be applied too
require("me.lsp.clangd")
require("me.lsp.jdtls")
require("me.lsp.pyright")
require("me.lsp.tsserver")

-- can be disabled/terminated by [:lsp disable/stop]
vim.lsp.enable({ "clangd", "jdtls", "pyright", "luals", "tsserver" })
