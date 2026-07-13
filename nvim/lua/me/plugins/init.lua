-- keep things simple here; only essentials
vim.pack.add({
    "https://github.com/junegunn/seoul256.vim",
    "https://github.com/mhinz/vim-signify",
    "https://codeberg.org/mfussenegger/nvim-dap"
})
-- config for plugins
vim.g.seoul256_srgb = 1
vim.cmd.colorscheme("seoul256-light")
require("me.plugins.dap")
