vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "qf", "checkhealth" },
    callback = function() vim.keymap.set("n", "q", vim.cmd.bdelete, { buffer = 0 }) end
}) -- close some windows quicker using [q] instead of typing :bd<CR> out

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function() vim.hl.on_yank() end
}) -- know what has been yanked

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = "[^l]*",
    callback = function() vim.cmd.cwindow() end
}) -- open the quickfix window whenever a qf command is executed

local session = require("me.common").get_session_filepath()
if session then
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("session_auto_save", { clear = true }),
        pattern = "*",
        callback = function() vim.cmd.mksession({ args = { session }, bang = true }) end
    })
    vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("session_auto_load", { clear = true }),
        pattern = "*", nested = true,
        callback = function() if vim.uv.fs_stat(session) then vim.cmd.source(session) end end
    })
end -- don't sessionize when opening specific file
