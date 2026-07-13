set nocompatible
set encoding=utf-8 title
set tabstop=4 shiftwidth=0 expandtab
set nomodeline noswapfile undofile
set ignorecase smartcase
set cursorline updatetime=512
set wildoptions=pum,tagfile,fuzzy
set showmatch splitright list
set listchars=tab:>\ ,trail:-,nbsp:+
let &showbreak = '+++ '

" unload redundant providers
if has('nvim')
  let g:loaded_node_provider = 0
  let g:loaded_perl_provider = 0
  let g:loaded_python3_provider = 0
  let g:loaded_ruby_provider = 0
  colorscheme unokai
endif

" :find command should search files
func! s:findfiles(cmdarg, _cmdcomp) abort
  let l:cmd = 'find . -type f'
  if has('nvim')
    let l:cmd = 'rg --files -. -L -S -g=!.git 2>/dev/null'
  endif
  let l:out = systemlist(l:cmd)
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
" escape VT220/xterm terminal emulator buffer
tnoremap <Esc> <C-\><C-n>

" extend vim grep abilities with ripgrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ -n\ $*
  set grepformat^=%f:%l:%c:%m
  " add [--hidden --no-ignore] for wildcard
  nnoremap <Space>g :silent grep! -S ''<Left>
  vnoremap <Space>g "0y:silent grep! -s '<C-r>0'<Left>
  nnoremap <Space>G :silent grep! -s '<C-r><C-w>'<CR>
else
  set grepprg=grep\ -rn\ $*
  nnoremap <Space>g :grep! -i ''<Left>
  vnoremap <Space>g "0y:grep! '<C-r>0'<Left>
  nnoremap <Space>G :grep! '<C-r><C-w>'<CR>
endif

" yank/paste to/from system clipboard
" all motions work the same as normal [y]
nnoremap <Space>y "+y
vnoremap <Space>y "+y
nnoremap <Space>p "+p
vnoremap <Space>p "+p
nnoremap <Space>P "+P

" quickly copy file name/path
nn <Space>n <Cmd>let @+=expand('%:t')<Bar>echo 'filename yanked'<CR>
nn <Space>N <Cmd>let @+=expand('%:p')<Bar>echo 'filepath yanked'<CR>

" open the quickfix window whenever a qf command is executed
autocmd QuickFixCmdPost [^l]* cwindow
autocmd FileType help,qf,checkhealth,dap-float nn <buffer> q <Cmd>bd<CR>
autocmd FileType vim setl tabstop=2

if has('nvim')
  autocmd TermOpen * nnoremap <buffer> q <Cmd>bd<CR>
  autocmd TextYankPost * silent! lua vim.hl.on_yank()
  autocmd FileType * silent! lua vim.treesitter.stop()

  lua require'utils'
  lua require'lspc'
  lua require'sessionize'
  lua require'bundle'
endif
