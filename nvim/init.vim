set nocp enc=utf-8 noml noswf nobk title hid ruler
set incsearch hls ignorecase smartcase
set autoindent showmatch splitright
set ts=4 sw=0 et ut=256 list wildoptions+=fuzzy
let &showbreak = '+++ '

" browse buffers/files
nmap <Space>o :ls t<CR>:buffer 
nmap - <Cmd>Explore<CR>
au FileType netrw nmap <buffer> <C-c> <Cmd>Rex<CR>

" extend vim grep abilities with ripgrep
if executable('rg')
  set grepformat^=%f:%l:%c:%m
  set grepprg=rg\ --vimgrep\ -n\ $*
  " add [--hidden --no-ignore] for wildcard
  nmap <Space>g :silent grep! -S ''<Left>
  xmap <Space>g "0y:silent grep! -s '<C-r>0'<Left>
  nmap <Space>G :silent grep! -s '<C-r><C-w>'<CR>
else
  set grepprg=grep\ -rn\ $*
  nmap <Space>g :grep! -i ''<Left>
  xmap <Space>g "0y:grep! '<C-r>0'<Left>
  nmap <Space>G :grep! '<C-r><C-w>'<CR>
endi

" open the quickfix window whenever a qf command is executed
au QuickFixCmdPost [^l]* cwindow
au FileType vim setl tabstop=2

" yank/paste to/from system clipboard
" all motions work the same as normal [y]
nmap <Space>y "+y
xmap <Space>y "+y
nmap <Space>p "+p
xmap <Space>p "+p
nmap <Space>P "+P

if has('nvim')
  lua vim.filetype.add{pattern={['.*%.log.*']='messages'}, extension={psql='sql'}}
  au TextYankPost * silent! lua vim.hl.on_yank()

  " :find command should search files
  func! s:findfiles(cmdarg, _cmdcomp) abort
    let l:out = systemlist($FZF_DEFAULT_COMMAND . ' 2>/dev/null')
    if v:shell_error != 0 | return [] | endi
    return empty(a:cmdarg) ? l:out : matchfuzzy(l:out, a:cmdarg)
  endf
  set findfunc=s:findfiles
  nmap <Space>f :find 
  nmap <Space>F :find <C-r><C-w><C-z>

  " unload redundant providers
  let g:loaded_node_provider = 0
  let g:loaded_perl_provider = 0
  let g:loaded_python3_provider = 0
  let g:loaded_ruby_provider = 0
  let g:loaded_matchit = 1
  set udf cul inccommand=split
  set completeopt+=menuone,noselect
  silent! colorscheme unokai

  " load lua stuff
  lua require'langserver'
  lua require'sessionize'
  lua require'plugin'
endi
