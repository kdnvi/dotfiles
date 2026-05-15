vim.diagnostic.config({virtual_text=true, underline=true})
vim.lsp.config("*", {
    on_attach=function(client, bufnr)
        vim.lsp.semantic_tokens.enable(false)
        vim.lsp.completion.enable(true, client.id, bufnr, {autotrigger=false})
        vim.lsp.inlay_hint.enable(true)

        -- see [:help vim.lsp.*] for documentation
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=bufnr})
        vim.keymap.set("n", "gr", vim.lsp.buf.references, {buffer=bufnr})
        vim.keymap.set("n", "gu", function()
            vim.lsp.buf.references({includeDeclaration=false})
        end, {buffer=bufnr}) -- show usages only
        vim.keymap.set("n", "gR", vim.lsp.buf.rename, {buffer=bufnr})
        vim.keymap.set("n", "<C-w>a", vim.lsp.buf.code_action, {buffer=bufnr})
    end,
    detached=true,
}) -- consistent behaviours across language servers

vim.api.nvim_create_autocmd("LspProgress", {
    group=vim.api.nvim_create_augroup("lsp_progress", {clear=true}),
    callback=function(e)
        if vim.api.nvim_get_mode().mode ~= "n" then return end
        local value = e.data.params.value
        if not value or not value.message then return end
        vim.api.nvim_echo({{value.message}}, false, {
            id="lsp."..e.data.params.token, kind="progress",
            source="vim.lsp", title=value.title,
            status=value.kind~="end"and"running"or"success",
            percent=value.percentage,
        }) -- only notify on normal mode for now
    end -- report language server progress
})

-- server configs, usually just launch cmd, applicable filetypes and root marker
-- some specific language settings can also be applied
require("khoa.lsp.clangd")
require("khoa.lsp.jdtls")
require("khoa.lsp.pyright")
require("khoa.lsp.tsserver")

-- can be disabled/terminated by [:lsp disable/stop] command
vim.lsp.enable({"clangd", "jdtls", "pyright", "tsserver"})
