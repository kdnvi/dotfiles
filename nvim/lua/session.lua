local common = require('common')
local session = common.get_session_filepath()
if session then
    vim.api.nvim_create_autocmd('BufWritePost', {
        group = vim.api.nvim_create_augroup('session_auto_save', {clear = true}),
        pattern = '*',
        callback = function() vim.cmd.mksession({args = {session}, bang = true}) end
    })
    vim.api.nvim_create_autocmd('VimEnter', {
        group = vim.api.nvim_create_augroup('session_auto_load', {clear = true}),
        pattern = '*', nested = true,
        callback = function() if vim.uv.fs_stat(session) then vim.cmd.source(session) end end
    })
end -- don't sessionize when opening specific file

vim.api.nvim_create_user_command('ClearSession', function()
    local f = common.get_session_filepath()
    assert(f and vim.uv.fs_stat(f), 'no session found')
    assert(os.remove(f), 'failed to remove session file: ' .. f)
    vim.notify('removed session file: ' .. f, vim.log.levels.INFO)
end, {nargs = 0, desc = 'cleanup session file'})
