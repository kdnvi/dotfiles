local M = {}
function M.get_active_lsp_client(name)
    local bufnr = vim.api.nvim_get_current_buf()
    local filters = { name = name }
    local client = vim.lsp.get_clients(filters)[1]

    if not client then
        filters["bufnr"] = bufnr
        vim.wait(5000, function() return next(vim.lsp.get_clients(filters)) ~= nil end)
        client = vim.lsp.get_clients(filters)[1]
    end

    assert(client, string.format("must have a [%s] client configured", name))
    return client, bufnr
end

function M.get_session_filepath()
    if vim.fn.argc() > 0 then return nil end

    local out = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { stdout = true }):wait()
    local branch = vim.trim(out.stdout or "")
    if out.code ~= 0 or #branch == 0 then
        return nil
    end -- returns nil as we want silent exit

    local name = vim.fn.sha256(vim.uv.cwd() .. "_" .. branch)
    local sessions_dir = vim.fn.stdpath("state") .. "/sessions"
    if not vim.uv.fs_stat(sessions_dir) then
        vim.uv.fs_mkdir(sessions_dir, 493) -- 0755
    end -- first start only

    return string.format("%s/%s.vim", sessions_dir, name)
end
return M
