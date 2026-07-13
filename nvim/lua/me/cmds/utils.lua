-- simple find finder using ripgrep
_G.find_files = function(cmd_arg, _cmd_comp)
    local out = vim.system(
        { "rg", "--files", "--smart-case", "--follow", "--hidden", "--glob=!.git" },
        { stdout = true }
    ):wait()
    if out.code ~= 0 then return {} end
    local files = vim.split(out.stdout or "", "\n", { plain = true, trimempty = true })
    if cmd_arg and #cmd_arg > 0 then files = vim.fn.matchfuzzy(files, cmd_arg) end
    return files
end -- returns list of file path strings
vim.opt.findfunc = "v:lua.find_files"

vim.api.nvim_create_user_command("ClearSession", function()
    local f = require("me.common").get_session_filepath()
    assert(f and vim.uv.fs_stat(f), "no session found")
    assert(os.remove(f), "failed to remove session file: " .. f)
    vim.notify("removed session file: " .. f, vim.log.levels.INFO)
end, { nargs = 0, desc = "cleanup session file" })

vim.api.nvim_create_user_command("Blame", function()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local start = math.max(1, line - 5)
    local finish = line + 5
    vim.cmd(string.format("!git blame -L %d,%d %%", start, finish))
end, { nargs = 0, desc = "git blame 10 lines surround" })
