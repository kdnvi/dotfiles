-- keep things simple here; only essentials
vim.pack.add{
    'https://github.com/junegunn/fzf.vim',
    'https://github.com/vimwiki/vimwiki',
}

vim.opt.runtimepath:append(vim.fn.has'mac'and'/opt/homebrew/opt/fzf'or'/usr/share/fzf')
vim.g.fzf_layout = {down='37%'}
vim.g.fzf_vim = {preview_window = {}}
vim.keymap.set('n', '<Space>o', vim.cmd.Buffers)
vim.keymap.set('n', '<Space>f', vim.cmd.Files)
vim.keymap.set('n', '<Space>s', '<Cmd>GFiles?<CR>')
vim.keymap.set('n', '<Space>j', vim.cmd.Jumps)
vim.keymap.set('n', '<Space>m', vim.cmd.Marks)
vim.keymap.set('n', '<Space>c', vim.cmd.Changes)

-- vimwiki
vim.g.vimwiki_list = {{path='~/work/vimwiki', syntax='markdown', ext='md'}}
vim.g.vimwiki_global_ext = 0
