vim.opt.swapfile = false
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 512
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.modeline = false
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.title = true
vim.opt.list = true
vim.opt.showbreak = "+++ "
vim.opt.wildoptions:append("fuzzy")
vim.opt.completeopt:append("fuzzy")
vim.filetype.add({
    extension = { psql = "sql" },
    pattern = { [".*%.log.*"] = "messages" }
})
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_netrwPlugin = 0
require("vim._core.ui2").enable({
    enable = true,
    msg = { targets = "cmd" }
})
vim.opt.termguicolors = false
vim.cmd.colorscheme("unokai")
