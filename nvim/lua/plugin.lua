vim.pack.add{
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/junegunn/fzf.vim',
}
vim.opt.runtimepath:append(vim.uv.os_uname().sysname=='Darwin'and'/opt/homebrew/opt/fzf'or'/usr/local/share/fzf')
vim.g.fzf_layout = {down='40%'}
vim.g.fzf_vim = {preview_window = {}}
vim.keymap.set('n', '<Space>s', '<Cmd>GFiles?<CR>')
vim.keymap.set('n', '<Space>f', vim.cmd.Files)
vim.keymap.set('n', '<Space>o', vim.cmd.Buffers)
vim.keymap.set('n', '<Space>c', vim.cmd.Changes)
vim.keymap.set('n', '<Space>m', vim.cmd.Marks)
vim.keymap.set('n', '<Space>j', vim.cmd.Jumps)
