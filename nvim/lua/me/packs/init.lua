-- keep things simple here, just essentials
vim.pack.add({
    "https://github.com/mhinz/vim-signify",
    "https://github.com/rebelot/kanagawa.nvim",
})

-- colors
require("kanagawa").setup({
    compile = true, -- make sure to run :KanagawaCompile command every time you make changes
    commentStyle = { italic = false },
    keywordStyle = { italic = false },
    dimInactive = true,
    colors = { theme = { all = { ui = { bg_gutter = "none" } } } }
})
vim.cmd.colorscheme("kanagawa-dragon")
