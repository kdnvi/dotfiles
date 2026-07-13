-- browse/search files/buffers
vim.keymap.set("n", "<Space>f", [[:find ]])
vim.keymap.set("n", "<Space>F", [[:find <C-r><C-w><C-z>]])
vim.keymap.set("n", "<Space>s", [[:ls t<CR>:buffer ]])
vim.keymap.set("n", "-", [[:edit %:.:h<C-z><C-z>]])

-- extend vim grep abilities with ripgrep
if vim.fn.executable("rg") > 0 then
    vim.opt.grepformat:prepend("%f:%l:%c:%m")
    vim.opt.grepprg = "rg --vimgrep --smart-case --line-number $*"
    -- add [--hidden --no-ignore] for wildcard
    vim.keymap.set("n", "<Space>g", [[:silent grep! ''<Left>]])
    vim.keymap.set("v", "<Space>g", [["0y:silent grep! '<C-r>0'<Left>]])
    vim.keymap.set("n", "<Space>G", [[:silent grep! '<C-r><C-w>'<CR>]])
end -- result can be accessible through qf list

-- command mode navigation
vim.keymap.set("c", "<C-a>", "<Home>")
vim.keymap.set("c", "<C-e>", "<End>")
vim.keymap.set("c", "<C-b>", "<Up>")
vim.keymap.set("c", "<C-f>", "<Down>")

-- copy to system clipboard
-- all motions work the same ways as normal [y]
vim.keymap.set({ "n", "v" }, "<C-w>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<C-w>p", [["+p]])
vim.keymap.set("n", "<C-w>P", [["+P]])
