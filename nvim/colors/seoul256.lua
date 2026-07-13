-- seoul256-light.lua
-- Ported from junegunn/seoul256.vim (light variant, bg=253)
-- https://github.com/junegunn/seoul256.vim - MIT License

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end

vim.o.background = "light"
vim.g.colors_name = "seoul256"

local bg = 253
local bg1 = 254
local bg2 = 255
local fg = 239

local rgb = {
    [16]  = "#000000",
    [22]  = "#006F00", [23]  = "#007173", [24]  = "#007299", [25]  = "#0074BE",
    [30]  = "#009799", [31]  = "#0099BD", [38]  = "#00BDDF",
    [52]  = "#730B00", [58]  = "#727100", [59]  = "#727272",
    [65]  = "#719872", [66]  = "#719899", [67]  = "#7299BC", [68]  = "#719CDF",
    [73]  = "#6FBCBD", [74]  = "#70BDDF",
    [88]  = "#9B1300", [89]  = "#9B1D72", [94]  = "#9A7200", [95]  = "#9A7372",
    [96]  = "#9A7599", [101] = "#999872", [103] = "#999ABD",
    [108] = "#98BC99", [109] = "#98BCBD", [110] = "#98BEDE", [116] = "#97DDDF",
    [125] = "#BF2172", [131] = "#BE7572", [137] = "#BE9873",
    [143] = "#BDBB72", [144] = "#BDBC98", [145] = "#BDBDBD",
    [151] = "#BCDDBD", [152] = "#BCDEDE", [153] = "#BCE0FF",
    [161] = "#E12672", [168] = "#E17899", [173] = "#E19972", [174] = "#E09B99",
    [179] = "#DFBC72", [181] = "#E0BEBC", [184] = "#DEDC00",
    [186] = "#DEDD99", [187] = "#DFDEBD", [189] = "#DFDFFF",
    [216] = "#FFBD98", [217] = "#FFBFBD", [218] = "#FFC0DE", [220] = "#FFDD00",
    [222] = "#FFDE99", [224] = "#FFDFDF", [230] = "#FFFFDF", [231] = "#FFFFFF",
    [232] = "#060606", [233] = "#171717", [234] = "#252525", [235] = "#333233",
    [236] = "#3F3F3F", [237] = "#4B4B4B", [238] = "#565656", [239] = "#616161",
    [240] = "#6B6B6B", [241] = "#757575",
    [249] = "#BFBFBF", [250] = "#C8C8C8", [251] = "#D1D0D1", [252] = "#D9D9D9",
    [253] = "#E1E1E1", [254] = "#E9E9E9", [255] = "#F1F1F1",
}

local function g(c)
    if c == "" or c == nil or c == "NONE" then return "NONE" end
    if c > 255 then c = 231 end
    return rgb[c] or "NONE"
end

local function hi(name, opts)
    local parts = { "highlight", name }
    if opts.ctermfg then
        parts[#parts + 1] = "ctermfg=" .. opts.ctermfg
        parts[#parts + 1] = "guifg=" .. g(opts.ctermfg)
    end
    if opts.ctermbg then
        parts[#parts + 1] = "ctermbg=" .. opts.ctermbg
        parts[#parts + 1] = "guibg=" .. g(opts.ctermbg)
    end
    if opts.cterm then
        parts[#parts + 1] = "cterm=" .. opts.cterm
        parts[#parts + 1] = "gui=" .. opts.cterm
    end
    if opts.guisp then
        parts[#parts + 1] = "guisp=" .. opts.guisp
    end
    vim.cmd(table.concat(parts, " "))
end

-- Normal
hi("Normal",       { ctermfg = fg,  ctermbg = bg })

-- UI
hi("LineNr",       { ctermfg = 101, ctermbg = bg - 2 })
hi("Visual",       { ctermbg = 152 })
hi("VisualNOS",    { ctermbg = 152 })
hi("CursorLine",   { ctermbg = bg - 1, cterm = "NONE" })
hi("CursorLineNr", { ctermfg = 131, ctermbg = bg - 1, cterm = "NONE" })
hi("CursorColumn", { ctermbg = bg - 1 })
hi("ColorColumn",  { ctermbg = bg - 2 })
hi("NormalFloat",  { ctermbg = bg - 1 })
hi("SignColumn",   { ctermfg = 173, ctermbg = bg })
hi("VertSplit",    { ctermfg = bg - 3, ctermbg = bg - 3 })
hi("WinSeparator", { ctermfg = bg - 3, ctermbg = bg - 3 })
hi("Folded",       { ctermfg = 101, ctermbg = bg - 2 })
hi("FoldColumn",   { ctermfg = 94,  ctermbg = bg - 2 })
hi("MatchParen",   { ctermbg = bg - 3 })
hi("NonText",      { ctermfg = 145 })
hi("SpecialKey",   { ctermfg = 145 })
hi("Conceal",      { ctermfg = fg - 2, ctermbg = bg + 2 })
hi("Ignore",       { ctermfg = bg - 3, ctermbg = bg })
hi("Directory",    { ctermfg = 95 })
hi("Title",        { ctermfg = 88 })
hi("Question",     { ctermfg = 88 })
hi("WarningMsg",   { ctermfg = 88 })
hi("MoreMsg",      { ctermfg = 173 })
hi("ModeMsg",      { ctermfg = 173 })

-- Search
hi("Search",       { ctermfg = 255, ctermbg = 74 })
hi("IncSearch",    { ctermfg = 220, ctermbg = 238 })

-- Popup menu
hi("Pmenu",        { ctermfg = fg,  ctermbg = bg - 2 })
hi("PmenuSel",     { ctermfg = 252, ctermbg = 95 })
hi("PmenuSbar",    { ctermbg = 65 })
hi("PmenuThumb",   { ctermbg = 23 })

-- Statusline / tabline
hi("StatusLine",     { ctermfg = 95,     ctermbg = 187 })
hi("StatusLineNC",     { ctermfg = bg - 2, ctermbg = 238 })
hi("StatusLineTerm",   { ctermfg = 95,     ctermbg = 187, cterm = "bold,reverse" })
hi("StatusLineTermNC", { ctermfg = bg - 2, ctermbg = 238, cterm = "bold,reverse" })
hi("TabLineFill",      { ctermfg = bg - 2 })
hi("TabLineSel",     { ctermfg = 187, ctermbg = 66 })
hi("TabLine",        { ctermfg = bg - 12, ctermbg = bg - 4 })
hi("WildMenu",       { ctermfg = 95,  ctermbg = 184 })

-- Diff
hi("DiffAdd",     { ctermfg = "NONE", ctermbg = 151 })
hi("DiffDelete",  { ctermfg = "NONE", ctermbg = 181 })
hi("DiffChange",  { ctermfg = "NONE", ctermbg = 189 })
hi("DiffText",    { ctermfg = "NONE", ctermbg = 224 })
hi("diffAdded",   { ctermfg = 65 })
hi("diffRemoved", { ctermfg = 131 })
vim.cmd("hi link diffLine Constant")

-- Error
hi("Error",    { ctermfg = bg1, ctermbg = 174 })
hi("ErrorMsg", { ctermfg = bg1, ctermbg = 168 })

-- Syntax
hi("Comment",         { ctermfg = 65 })
hi("Number",          { ctermfg = 95 })
hi("Float",           { ctermfg = 95 })
hi("Boolean",         { ctermfg = 168 })
hi("String",          { ctermfg = 30 })
hi("Constant",        { ctermfg = 23 })
hi("Character",       { ctermfg = 168 })
hi("Delimiter",       { ctermfg = 94 })
hi("StringDelimiter", { ctermfg = 94 })
hi("Statement",       { ctermfg = 66 })
hi("Conditional",     { ctermfg = 31 })
hi("Repeat",          { ctermfg = 67 })
hi("Todo",            { ctermfg = 125, ctermbg = bg2 })
hi("Function",        { ctermfg = 58 })
hi("Define",          { ctermfg = 131 })
hi("Macro",           { ctermfg = 131 })
hi("Include",         { ctermfg = 131 })
hi("PreCondit",       { ctermfg = 131 })
hi("PreProc",         { ctermfg = 58 })
hi("Identifier",      { ctermfg = 96 })
hi("Type",            { ctermfg = 94 })
hi("Operator",        { ctermfg = 131 })
hi("Keyword",         { ctermfg = 168 })
hi("Exception",       { ctermfg = 161 })
hi("Structure",       { ctermfg = 23 })
hi("Underlined",      { ctermfg = 168, cterm = "underline" })
hi("Special",         { ctermfg = 173 })

-- Spelling
hi("SpellBad",   { ctermfg = 125, cterm = "underline", guisp = rgb[125] })
hi("SpellCap",   { ctermfg = 25,  cterm = "underline", guisp = rgb[25] })
hi("SpellLocal", { ctermfg = 31,  cterm = "underline", guisp = rgb[31] })
hi("SpellRare",  { ctermfg = 96,  cterm = "underline", guisp = rgb[96] })

-- Extra whitespace
hi("ExtraWhitespace", { ctermbg = bg - 2 })


-- Treesitter overrides (only where we differ from Neovim defaults)
vim.cmd("hi! link @variable Normal")
vim.cmd("hi! link @constructor Type")
