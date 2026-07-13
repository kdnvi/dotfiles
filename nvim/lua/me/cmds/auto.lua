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

local common = require("me.common")
-- fetch jdt:// content and load it into a buffer
vim.api.nvim_create_autocmd("BufReadCmd", {
    group = vim.api.nvim_create_augroup("jdtls_class_file_content", { clear = true }),
    pattern = "jdt://*",
    callback = function(args)
        local client, bufnr = common.get_active_lsp_client("jdtls")
        local uri = args.match

        vim.bo[bufnr].modifiable = true
        vim.bo[bufnr].swapfile = false
        vim.bo[bufnr].buftype = "nofile"
        vim.bo[bufnr].bufhidden = "wipe"
        vim.bo[bufnr].filetype = "java"

        local content
        local function handler(err, result)
            assert(not err, vim.inspect(err))
            assert(result, "jdtls client must return result for java/classFileContents")
            content = result
            local normalized = string.gsub(result, "\r\n", "\n")
            local source_lines = vim.split(normalized, "\n", { plain = true })
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, source_lines)
            vim.bo[bufnr].modifiable = false
        end

        client:request("java/classFileContents", { uri = uri }, handler, bufnr)
        vim.wait(5000, function() return content ~= nil end)
    end
})

local session = common.get_session_filepath()
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
