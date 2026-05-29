vim.filetype.add({
    pattern = {['.*%.log.*']='messages'},
    extension = {psql='sql'},
}) -- ft mapping

vim.api.nvim_create_autocmd('FileType', {pattern = '*', callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if lang and vim.treesitter.language.add(lang) then vim.treesitter.start(args.buf, lang) end
end}) -- enable treesitter highlighting if possible

-- ui2 experimental
require'vim._core.ui2'.enable{enable=true, msg={targets='cmd'}}

vim.api.nvim_create_user_command('Blame', function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local start = math.max(1, line-5)
    local finish = line + 5
    vim.cmd(string.format('!git blame -L %d,%d %%', start, finish))
end, {nargs=0, desc='git blame 5 lines surround'})

vim.keymap.set('n', '<Space>c', function()
    vim.cmd[[terminal git diff --color=always %]]
end) -- show current file changes
