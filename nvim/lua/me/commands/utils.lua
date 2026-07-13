local api = vim.api
local user_command = api.nvim_create_user_command
local log = vim.log.levels
local notify = vim.notify

-- simple find finder using ripgrep
_G.rg_find_func = function(cmd_arg, _)
    local result = vim.system({ "rg", "--files", "--hidden", "--follow" }, { text = true }):wait()
    if result.code ~= 0 then return {} end
    local files = vim.split(vim.trim(result.stdout or ""), "\n", { plain = true, trimempty = true })
    if type(cmd_arg) == "string" and #cmd_arg > 0 then
        local lower = cmd_arg:lower()
        files = vim.tbl_filter(function(f)
            return f:lower():find(lower, 1, true) ~= nil
        end, files)
    end -- case-insensitive filter
    return files
end     -- returns list of file path strings
vim.opt.findfunc = "v:lua.rg_find_func"

-- remove session files for current repo
user_command("CleanSession", function()
    local sfile = require("me.common").get_session_filepath()
    assert(sfile and vim.uv.fs_stat(sfile), "no session found")
    assert(os.remove(sfile), "failed to remove session file: " .. sfile)
    notify("removed session file: " .. sfile, log.INFO)
end, { nargs = 0 })
