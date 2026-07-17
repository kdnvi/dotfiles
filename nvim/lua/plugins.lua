vim.pack.add{
    'https://github.com/junegunn/fzf.vim',
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/vimwiki/vimwiki',
}

-- fzf
vim.opt.runtimepath:append(vim.fn.has'mac'and'/opt/homebrew/opt/fzf'or'/usr/share/fzf')
vim.g.fzf_layout = {down='41%'}
vim.g.fzf_vim = {preview_window = {}}
vim.keymap.set('n', '<leader>o', vim.cmd.Buffers)
vim.keymap.set('n', '<leader>f', vim.cmd.Files)
vim.keymap.set('n', '<leader>s', '<Cmd>GFiles?<CR>')
vim.keymap.set('n', '<leader>j', vim.cmd.Jumps)
vim.keymap.set('n', '<leader>m', vim.cmd.Marks)
vim.keymap.set('n', '<leader>c', vim.cmd.Changes)

-- vimwiki
vim.g.vimwiki_list = {{path='~/work/vimwiki', syntax='markdown', ext='md'}}
vim.g.vimwiki_global_ext = 0
vim.api.nvim_create_user_command('ExportDocx', function()
    local src = vim.fn.expand('%:p')
    local wiki_path = vim.fn.expand(vim.g.vimwiki_list[1].path)
    local docx_dir = wiki_path..'/docx/'
    vim.fn.mkdir(docx_dir, 'p')
    local out = docx_dir..vim.fn.expand('%:t:r')..'.docx'
    vim.system({'pandoc', src, '-o', out}, {}, function(result)
        vim.schedule(function()
            if result.code == 0 then
                vim.notify('exported to '..out)
            else
                vim.notify('pandoc export failed', vim.log.levels.ERROR)
            end
        end)
    end)
end, {nargs=0, desc='export current markdown to docx'})
