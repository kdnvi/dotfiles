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

vim.api.nvim_create_autocmd("LspProgress", {
    group = vim.api.nvim_create_augroup("lsp_progress", { clear = true }),
    callback = function(e)
        if vim.fn.mode() == "i" then return end
        local value = e.data.params.value
        if not value or not value.message then return end
        vim.api.nvim_echo({ { value.message or "done" } }, false, {
            id = "lsp." .. e.data.client_id,
            kind = "progress",
            source = "vim.lsp",
            title = value.title,
            status = value.kind ~= "end" and "running" or "success",
            percent = value.percentage,
        })
    end -- language server progress report
})

-- server configs, usually just launch cmd, applicable filetypes and root marker
-- some specific language settings can also be applied
require("me.lsp.clangd")
require("me.lsp.jdtls")
require("me.lsp.pyright")
require("me.lsp.tsserver")

-- can be disabled/terminated by [:lsp disable/stop] command
vim.lsp.enable({ "clangd", "jdtls", "pyright", "tsserver" })
