set nocompatible encoding=utf-8
set title hidden number relativenumber
set nomodeline noswapfile nobackup
set incsearch hlsearch autoindent
set tabstop=4 shiftwidth=0 expandtab
set ignorecase smartcase updatetime=512
set showmatch splitright list
set wildoptions=pum,tagfile,fuzzy
let &showbreak = '+++ '

" browse buffers/files
nmap <Space>o :ls t<CR>:buffer 
nmap - <Cmd>Explore<CR>
au FileType netrw nmap <buffer> <C-c> <Cmd>Rex<CR>

" extend vim grep abilities with ripgrep
set grepformat^=%f:%l:%c:%m
if executable('rg')
  set grepprg=rg\ --vimgrep\ -n\ $*
  " add [--hidden --no-ignore] for wildcard
  nmap <Space>g :silent grep! -S ''<Left>
  vmap <Space>g "0y:silent grep! -s '<C-r>0'<Left>
  nmap <Space>G :silent grep! -s '<C-r><C-w>'<CR>
else
  set grepprg=grep\ -rn\ $*
  nmap <Space>g :grep! -i ''<Left>
  vmap <Space>g "0y:grep! '<C-r>0'<Left>
  nmap <Space>G :grep! '<C-r><C-w>'<CR>
endi

" open the quickfix window whenever a qf command is executed
au QuickFixCmdPost [^l]* cwindow
au FileType help,qf,checkhealth nmap <buffer> q <Cmd>bd<CR>
au FileType vim setl tabstop=2

if has('nvim')
  lua vim.filetype.add{pattern={['.*%.log.*']='messages'}, extension={psql='sql'}}
  au TextYankPost * silent! lua vim.hl.on_yank()

  " escape VT220/xterm terminal emulator buffer
  tmap <Esc> <C-\><C-n>
  nmap <Space>N <Cmd>let @+=expand('%:t')<CR>
  nmap <Space>n <Cmd>let @+=expand('%')<CR>

  " unload redundant providers
  let g:loaded_node_provider = 0
  let g:loaded_perl_provider = 0
  let g:loaded_python3_provider = 0
  let g:loaded_ruby_provider = 0
  let g:loaded_matchit = 1
  set undofile completeopt+=menuone,noselect
  set inccommand=split cursorline
  silent! colorscheme unokai

  " :find command should search files
  func! s:findfiles(cmdarg, _cmdcomp) abort
    let l:out = systemlist('rg --files -. -L -S -g=!.git 2>/dev/null')
    if v:shell_error != 0 | return [] | endi
    return empty(a:cmdarg) ? l:out : matchfuzzy(l:out, a:cmdarg)
  endf
  set findfunc=s:findfiles
  nmap <Space>f :find 
  nmap <Space>F :find <C-r><C-w><C-z>

  " browse git modified/untracked files
  func! s:gitfiles() abort
    let l:out = systemlist('git ls-files -m -o --exclude-standard 2>/dev/null')
    if v:shell_error != 0 || empty(l:out) | echo 'no changes' | return | endi
    let l:files = map(l:out, {_, f -> {'filename': f, 'lnum': 1, 'text': fnamemodify(f, ':t')}})
    call setloclist(0, l:files, 'r') | lopen
  endf
  command! GFiles call <SID>gitfiles()
  nmap <Space>s <Cmd>GFiles<CR>

  " next 5 line git blame
  command! -nargs=0 Blame exe printf('!git blame -L %d,%d %%', line('.'), line('.')+5)

  " yank/paste to/from system clipboard
  " all motions work the same as normal [y]
  nmap <Space>y "+y
  vmap <Space>y "+y
  nmap <Space>p "+p
  vmap <Space>p "+p
  nmap <Space>P "+P

  " load lua stuff
  lua require'lspc'
  lua require'sessionize'
endi
