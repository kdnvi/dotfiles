local set = vim.opt
local g = vim.g
set.swapfile = false
set.showmatch = true
set.ignorecase = true
set.smartcase = true
set.updatetime = 512
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.expandtab = true
set.shiftround = true
set.undofile = true
set.title = true
set.list = true
set.showbreak = "+++ "
set.visualbell = true
set.cursorline = true
set.number = true
set.termguicolors = false
vim.cmd.colorscheme("wildcharm")
vim.filetype.add({
    extension = { psql = "sql", mdc = "markdown" },
    pattern = { [".*%.log.*"] = "messages" }
})
require("vim._core.ui2").enable({ msg = { target = "cmd" } })
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_netrwPlugin = 0
