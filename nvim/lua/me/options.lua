local set = vim.opt
local g = vim.g
set.swapfile = false
set.showmatch = true
set.ignorecase = true
set.smartcase = true
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.expandtab = true
set.shiftround = true
set.undofile = true
set.title = true
set.visualbell = true
set.cursorline = true
set.number = true
set.list = true
set.showbreak = "+++ "
set.fillchars:append({ vert = "|" })
vim.filetype.add({
    extension = { psql = "sql", mdc = "markdown" },
    pattern = { [".*%.log.*"] = "messages" }
})
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
