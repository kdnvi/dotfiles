set nocp enc=utf-8 noml noswf nobk title hid
set incsearch hlsearch ignorecase smartcase
set autoindent showmatch splitright ruler
set ts=4 sw=0 et ut=256 list wildoptions+=fuzzy
let &showbreak = '+++ '

" extend vim grep abilities with ripgrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --hidden\ -n\ $*
  set grepformat^=%f:%l:%c:%m
  " use [--no-ignore] for wildcard
  nmap <Space>g :silent grep! -S ''<Left>
  xmap <Space>g "0y:silent grep! -s '<C-r>0'<Left>
  nmap <Space>G :silent grep! -s '<C-r><C-w>'<CR>
else
  set grepprg=grep\ -HIrn\ $*
  nmap <Space>g :grep! -i ''<Left>
  xmap <Space>g "0y:grep! '<C-r>0'<Left>
  nmap <Space>G :grep! '<C-r><C-w>'<CR>
endif

" browse buffers/files
nmap <Space>o <Cmd>ls t<CR>:buffer 
nmap - <Cmd>Explore<CR>
au FileType netrw nmap <buffer> <C-c> <Cmd>Rex<CR>

" :find command should search files
func! s:findfiles(cmdarg, _cmdcomp) abort
  let l:out = systemlist('rg --files -. -L -S -g=!.git 2>/dev/null')
  if v:shell_error != 0 | return [] | endif
  return empty(a:cmdarg) ? l:out : matchfuzzy(l:out, a:cmdarg)
endfunc
set findfunc=s:findfiles
nmap <Space>f :find 
nmap <Space>F :find <C-r><C-w><C-z>

" browse git modified/untracked files
func! s:gitfiles(arglead, _cmdline, _cursorpos) abort
  let l:out = systemlist('git ls-files -m -o --exclude-standard 2>/dev/null')
  if v:shell_error != 0 || empty(l:out) | return [] | endif
  return empty(a:arglead) ? l:out : matchfuzzy(l:out, a:arglead)
endfunc
command! -nargs=1 -complete=customlist,<SID>gitfiles GFiles
      \ exe 'edit ' . fnameescape(<q-args>)
nmap <Space>s :GFiles <C-z>

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
  au TextYankPost * silent! lua vim.hl.on_yank()
  lua vim.filetype.add{pattern={['.*%.log.*']='messages'}, extension={psql='sql'}}

  " unload redundant providers
  let g:loaded_node_provider = 0
  let g:loaded_perl_provider = 0
  let g:loaded_python3_provider = 0
  let g:loaded_ruby_provider = 0
  let g:loaded_matchit = 1
  set undofile cursorline inccommand=split
  set completeopt+=menuone,noselect

  " copy file name/path
  nmap <Space>N <Cmd>let @+=expand('%:p')<Bar>echo 'filepath yanked'<CR>
  nmap <Space>n <Cmd>let @+=expand('%')<Bar>echo 'filename yanked'<CR>

  " load lua stuff
  lua require'langserver'
  lua require'diffsign'
endif
