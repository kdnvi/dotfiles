vim.diagnostic.config({virtual_text=true, underline=true})
vim.lsp.config('*', {
    on_attach=function(client, bufnr)
        vim.lsp.semantic_tokens.enable(false)
        vim.lsp.completion.enable(true, client.id, bufnr, {autotrigger=false})
        vim.lsp.inlay_hint.enable(true)

        -- see [:help vim.lsp.*] for documentation
        vim.keymap.set('n', 'gru', function()
            vim.lsp.buf.references({includeDeclaration=false})
        end, {buffer=bufnr}) -- show usages only

        vim.api.nvim_create_autocmd('LspProgress', {
            group=vim.api.nvim_create_augroup('lsp_progress', {clear=true}),
            buffer=bufnr, callback=function(e)
                if vim.api.nvim_get_mode().mode ~= 'n' then return end
                local value = e.data.params.value
                if not value or not value.message then return end
                vim.api.nvim_echo({{value.message}}, false, {
                    id='lsp.'..e.data.params.token, kind='progress',
                    source='vim.lsp', title=value.title,
                    status=value.kind~='end'and'running'or'success',
                    percent=value.percentage,
                }) -- only notify on normal mode for now
            end -- report language server progress
        })
    end,
    detached=true,
}) -- consistent behaviours across language servers

-- server configs, usually just launch cmd, applicable filetypes and root marker
-- some specific language settings can also be applied
require('lsp.clangd')
require('lsp.jdtls')
require('lsp.pyright')
require('lsp.tsserver')

-- can be disabled/terminated by [:lsp disable/stop] command
vim.lsp.enable({'clangd', 'jdtls', 'pyright', 'tsserver'})
