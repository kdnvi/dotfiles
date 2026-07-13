vim.filetype.add({
    pattern = {['.*%.log.*']='messages'},
    extension = {psql='sql'},
}) -- ft mapping

vim.api.nvim_create_user_command('Blame', function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local start = math.max(1, line-5)
    local finish = line + 5
    vim.cmd(string.format('!git blame -L %d,%d %%', start, finish))
end, {nargs=0, desc='git blame 5 lines surround'})

vim.keymap.set('n', '<Space>d', function()
    vim.cmd[[terminal git diff --color=always %]]
end) -- show current file changes
