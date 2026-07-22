set nocp enc=utf-8 noml noswf nobk title hid
set incsearch hlsearch ignorecase smartcase
set autoindent showmatch splitright ruler
set ts=4 sw=0 et ut=256 list wildoptions+=fuzzy
let &showbreak = '+++ '

" extend vim grep abilities with git-grep
call system('git rev-parse --is-inside-work-tree &>/dev/null')
let s:findcmd = 'find . -type f'
if v:shell_error == 0
  let s:findcmd = 'git ls-files -c -o --exclude-standard'
  set grepformat^=%f:%l:%c:%m
  set grepprg=git\ grep\ --column\ -n\ $*
else
  set grepprg=grep\ -HIrn\ $*
endif
" use [--untracked --no-exclude-standard] for wildcard
nmap <Space>g :grep! -i ''<Left>
xmap <Space>g "0y:grep! '<C-r>0'<Left>
nmap <Space>G :grep! '<C-r><C-w>'<CR>

" browse buffers/files
nmap <Space>o <Cmd>ls t<CR>:buffer 
nmap - <Cmd>Explore<CR>
au FileType netrw nmap <buffer> <C-c> <Cmd>Rex<CR>


" :find command should search files
func! s:findfiles(cmdarg, _cmdcomp) abort
  let l:out = systemlist(s:findcmd . ' 2>/dev/null')
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
endif
