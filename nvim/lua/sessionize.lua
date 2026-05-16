local function get_session_filepath()
    if vim.fn.argc()>0 then return nil end
    -- returns nil as we want silent exit
    local out = vim.system({'git', 'rev-parse', '--abbrev-ref', 'HEAD'}, {stdout=true}):wait()
    local branch = vim.trim(out.stdout or '')
    if out.code~=0 or #branch==0 then return nil end

    local name = vim.fn.sha256(vim.uv.cwd()..'_'..branch)
    local dir = vim.fn.stdpath'state'..'/sessions'
    if not vim.uv.fs_stat(dir) then vim.uv.fs_mkdir(dir, 493) end -- 0755
    return string.format('%s/%s.vim', dir, name)
end

local filepath = get_session_filepath()
if filepath then
    vim.api.nvim_create_autocmd('BufWritePost', {
        group = vim.api.nvim_create_augroup('session_auto_save', {clear=true}),
        pattern = '*', callback = function() vim.cmd.mksession({args={filepath}, bang=true}) end
    })
    vim.api.nvim_create_autocmd('VimEnter', {
        group = vim.api.nvim_create_augroup('session_auto_load', {clear=true}), nested = true,
        pattern = '*', callback = function() if vim.uv.fs_stat(filepath) then vim.cmd.source(filepath) end end
    })
end -- don't sessionize when opening specific file

vim.api.nvim_create_user_command('ClearSession', function()
    local f = get_session_filepath()
    assert(f and vim.uv.fs_stat(f), 'no session found')
    local ok, err_msg = os.remove(f)
    assert(ok, err_msg)
    vim.notify('removed session file: '..f, vim.log.levels.INFO)
end, {nargs=0, desc='clear session file'})
