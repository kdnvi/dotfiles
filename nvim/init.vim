set nocp enc=utf-8 noml noswf nobk title hid
set incsearch hlsearch ignorecase smartcase ruler
set autoindent showmatch splitright ruler nu rnu
set ts=4 sw=0 et ut=256 list wildoptions+=fuzzy
let &showbreak = '+++ '

" space as leader key
let mapleader = ' '
nnoremap <Space> <Nop>

" extend vim grep abilities with git-grep
call system('git rev-parse --is-inside-work-tree &>/dev/null')
if v:shell_error == 0
  set grepprg=git\ grep\ --column\ -n\ $*
  set grepformat^=%f:%l:%c:%m
else
  set grepprg=grep\ -HIrn\ $*
endif
" use [--untracked --no-exclude-standard] for wildcard
nmap <leader>g :grep! -i ''<Left>
xmap <leader>g "0y:grep! '<C-r>0'<Left>
nmap <leader>G :grep! '<C-r><C-w>'<CR>

" open the quickfix window whenever a qf command is executed
au QuickFixCmdPost [^l]* cwindow
au FileType vim setl tabstop=2

" yank/paste to/from system clipboard
" all motions work the same as normal [y]
nmap <leader>y "+y
xmap <leader>y "+y
nmap <leader>p "+p
xmap <leader>p "+p
nmap <leader>P "+P

if has('nvim')
  au TextYankPost * silent! lua vim.hl.on_yank()
  lua vim.filetype.add{pattern={['.*%.log.*']='messages'}, extension={psql='sql'}}

  " unload redundant providers
  let g:loaded_node_provider = 0
  let g:loaded_perl_provider = 0
  let g:loaded_python3_provider = 0
  let g:loaded_ruby_provider = 0
  let g:loaded_netrw = 1
  let g:loaded_netrwPlugin = 1
  let g:loaded_matchit = 1
  set undofile cul inccommand=split
  set completeopt+=menuone,noselect

  " copy file name/path
  nmap <leader>n <Cmd>let @+=expand('%')<Bar>echo 'filename yanked'<CR>
  nmap <leader>N <Cmd>let @+=expand('%:p')<Bar>echo 'filepath yanked'<CR>

  " load lua stuff
  lua require'sessionize'
  lua require'langserver'
  lua require'plugins'
endif
