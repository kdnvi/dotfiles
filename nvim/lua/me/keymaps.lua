local map = vim.keymap.set
local set = vim.opt

-- extend vim grep abilities with ripgrep
if vim.fn.executable("rg") > 0 then
    set.grepformat:prepend("%f:%l:%c:%m")
    set.grepprg = "rg --vimgrep $*"
    -- add `--hidden --no-ignore` for wildcard
    map("n", "<Space>g", [[:silent grep! ''<Left>]])
    map("v", "<Space>g", [["0y:silent grep! '<C-r>0'<Left>]])
    map("n", "<Space>G", [[:silent grep! '<C-r><C-w>'<CR>]])
end -- result can be accessible through qf list

-- some proper ways to browse/search
map("n", "<Space>f", [[:find ]])
map("n", "<Space>F", [[:find <C-r><C-w><C-z>]])
map("n", "<C-Space>", [[:ls t<CR>:buffer ]])
map("n", "<C-j>", [[:edit %:.:h<C-z><C-z><C-p>]])
map("n", "-", "<C-^>")

-- copy to system clipboard
-- all motions after `<Space>y` work the same as normal `y`
map({ "n", "v" }, "<Space>y", [["+y]])
map({ "n", "v" }, "<Space>p", [["+p]])
map("n", "<Space>P", [["+P]])

-- command mode navigation
map("c", "<M-Left>", "<C-Left>")
map("c", "<M-Right>", "<C-Right>")
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")
map("c", "<M-BS>", "<C-w>")
map("c", "<C-b>", "<Up>")
map("c", "<C-f>", "<Down>")

-- navigate between terminal buffers easier
map("t", "<Esc><Esc>", [[<C-\><C-n>]])
map("t", "<C-w><C-h>", [[<C-\><C-n><C-w><C-h>]])
map("t", "<C-w><C-j>", [[<C-\><C-n><C-w><C-j>]])
map("t", "<C-w><C-k>", [[<C-\><C-n><C-w><C-k>]])
map("t", "<C-w><C-l>", [[<C-\><C-n><C-w><C-l>]])
map("t", "<C-w>h", [[<C-\><C-n><C-w>h]])
map("t", "<C-w>j", [[<C-\><C-n><C-w>j]])
map("t", "<C-w>k", [[<C-\><C-n><C-w>k]])
map("t", "<C-w>l", [[<C-\><C-n><C-w>l]])
