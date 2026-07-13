local M = {}

function M.get_active_lsp_client(lsname)
    local lsp = vim.lsp
    local buf = vim.api.nvim_get_current_buf()
    local filters = { name = lsname }
    local client = lsp.get_clients(filters)[1]

    if not client then
        filters["bufnr"] = buf
        vim.wait(5000, function() return next(lsp.get_clients(filters)) ~= nil end)
        client = lsp.get_clients(filters)[1]
    else
        lsp.buf_attach_client(buf, client.id)
    end

    assert(client, string.format("must have a [%s] client configured", lsname))
    return client, buf
end

local _session_path_cache = nil
function M.get_session_filepath()
    if _session_path_cache then return _session_path_cache end

    local result = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }):wait()
    local branch = vim.trim(result.stdout or "")
    if result.code ~= 0 or #branch == 0 then
        return nil
    end -- returns nil as we want silent exit

    local name = vim.fn.sha256(vim.uv.cwd() .. "_" .. branch)
    local sessions_dir = vim.fn.stdpath("state") .. "/sessions"
    if not vim.uv.fs_stat(sessions_dir) then
        vim.uv.fs_mkdir(sessions_dir, 493) -- 0755
    end -- first run only

    _session_path_cache = string.format("%s/%s.vim", sessions_dir, name)
    return _session_path_cache
end

return M
