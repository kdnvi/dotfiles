set nomodeline title
set tabstop=4 shiftwidth=0
set expandtab showmatch
set noswapfile undofile
set cursorline updatetime=512
set wildoptions+=fuzzy
set completeopt+=fuzzy
set ignorecase smartcase
set splitright list
let &showbreak = '+++ '
colorscheme unokai

" unload redundant providers
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider = 0

" :find command should search files
func! s:findfiles(cmdarg, _cmdcomp) abort
  let l:out = systemlist('rg --files -. -L -S -g=!.git 2>/dev/null')
  if v:shell_error != 0 | return [] | endif
  return empty(a:cmdarg) ? l:out : matchfuzzy(l:out, a:cmdarg)
endfunc
set findfunc=s:findfiles
nnoremap <Space>f :find 
nnoremap <Space>F :find <C-r><C-w><C-z>
nnoremap <Space>s :vert sfind 

" browse buffers/files
nnoremap <Space>o :ls t<CR>:buffer 
nnoremap - <Cmd>Explore<CR>
au FileType netrw nn <buffer> <C-c> <Cmd>Rexplore<CR>

" extend vim grep abilities with ripgrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ -n\ $*
  set grepformat^=%f:%l:%c:%m
  " add [--hidden --no-ignore] for wildcard
  nnoremap <Space>g :silent grep! -S ''<Left>
  vnoremap <Space>g "0y:silent grep! -s '<C-r>0'<Left>
  nnoremap <Space>G :silent grep! -s '<C-r><C-w>'<CR>
endif

" yank/paste to/from system clipboard
" all motions work the same as normal [y]
nnoremap <C-w>y "+y
vnoremap <C-w>y "+y
nnoremap <C-w>p "+p
vnoremap <C-w>p "+p
nnoremap <C-w>P "+P

" quickly copy file name/path
nn <Space>n <Cmd>let @+=expand('%:t')<Bar>echo 'filename yanked'<CR>
nn <Space>p <Cmd>let @+=expand('%')<Bar>echo 'filepath yanked'<CR>
nn <Space>P <Cmd>let @+=expand('%:p')<Bar>echo 'fullpath yanked'<CR>

" moving in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Up>
cnoremap <C-f> <Down>
" escape VT220/xterm terminal emulator buffer
tnoremap <Esc> <C-\><C-n>

" open the quickfix window whenever a qf command is executed
autocmd QuickFixCmdPost [^l]* cwindow
autocmd FileType help,qf,checkhealth,dap-float nn <buffer> q <Cmd>bd<CR>
autocmd TermOpen * nnoremap <buffer> q <Cmd>bd<CR>
autocmd TextYankPost * silent! lua vim.hl.on_yank()
autocmd FileType * silent! lua vim.treesitter.stop()
autocmd FileType vim setl tabstop=2

lua require'utils'
lua require'lspc'
lua require'sessionize'
lua require'bundle'
