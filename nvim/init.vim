set noswapfile showmatch
set smartcase ignorecase
set shiftwidth=2 tabstop=2
set expandtab shiftround
set nomodeline undofile
set cursorline title list
set splitright updatetime=512
set wildoptions+=fuzzy
set completeopt+=fuzzy
let &showbreak = '+++ '
set notermguicolors
colorscheme unokai

" unload unused providers
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_netrwPlugin = 0

" :find command should search files
func! s:findfiles(cmdarg, _cmdcomp) abort
  let l:out = systemlist('rg --files --hidden -L -S -g=!.git 2>/dev/null')
  if v:shell_error != 0 | return [] | endif
  return empty(a:cmdarg) ? l:out : matchfuzzy(l:out, a:cmdarg)
endfunc
set findfunc=s:findfiles
nnoremap <Space>f :find 
nnoremap <Space>F :find <C-r><C-w><C-z>
nnoremap <Space>s :vert sfind 

" browse buffers/files
nnoremap <Space>o :ls t<CR>:buffer 
nnoremap - :edit %:.:h<C-z><C-z>

" extend vim grep abilities with ripgrep
if executable('rg')
  set grepformat^=%f:%l:%c:%m
  set grepprg=rg\ --vimgrep\ --line-number\ $*
  " add [--hidden --no-ignore] for wildcard
  nnoremap <Space>g :silent grep! -S ''<Left>
  nnoremap <Space>G :silent grep! -s '<C-r><C-w>'<CR>
  vnoremap <Space>g "0y:silent grep! -s '<C-r>0'<Left>
endif

" yank/paste to/from system clipboard
" all motions work the same as normal [y]
nnoremap <C-w>y "+y
vnoremap <C-w>y "+y
nnoremap <C-w>p "+p
vnoremap <C-w>p "+p
nnoremap <C-w>P "+P

" quickly copy file name/path
nn <Space>n <Cmd>let @+=expand('%:t')<Bar>echo 'filename copied'<CR>
nn <Space>p <Cmd>let @+=expand('%')<Bar>echo 'filepath copied'<CR>
nn <Space>P <Cmd>let @+=expand('%:p')<Bar>echo 'absolute filepath copied'<CR>

" moving in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Up>
cnoremap <C-f> <Down>

" open the quickfix window whenever a qf command is executed
autocmd QuickFixCmdPost [^l]* cwindow
autocmd TextYankPost * silent! lua vim.hl.on_yank()
autocmd FileType help,qf,checkhealth nn <buffer> q <Cmd>bd<CR>
autocmd FileType fish,bash,sh,lua setl sw=4 ts=4

lua require('utils')
lua require('lsp')
lua require('session')
