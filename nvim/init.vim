set nocp enc=utf-8 noml noswf nobk title hid
set incsearch hlsearch ignorecase smartcase ruler
set autoindent showmatch splitright ruler nu rnu
set ts=4 sw=0 et ut=256 list wildoptions+=fuzzy
let &showbreak = '+++ '

" extend vim grep abilities with git-grep
call system('git rev-parse --is-inside-work-tree &>/dev/null')
if v:shell_error == 0
  set grepprg=git\ grep\ --column\ -n\ $*
  set grepformat^=%f:%l:%c:%m
else
  set grepprg=grep\ -HIrn\ $*
endif
" use [--untracked --no-exclude-standard] for wildcard
nmap <Space>g :grep! -i ''<Left>
xmap <Space>g "0y:grep! '<C-r>0'<Left>
nmap <Space>G :grep! '<C-r><C-w>'<CR>

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
  au FileType * silent! lua vim.treesitter.stop()
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
  set undofile cc=80 inccommand=split
  set completeopt+=menuone,noselect

  " color
  silent! colorscheme unokai
  hi! NormalNC ctermbg=NONE guibg=NONE
  hi! Normal ctermbg=NONE guibg=NONE

  " copy file name/path
  nmap <Space>n <Cmd>let @+=expand('%')<Bar>echo 'filename yanked'<CR>
  nmap <Space>N <Cmd>let @+=expand('%:p')<Bar>echo 'filepath yanked'<CR>

  " load lua stuff
  lua require'langserver'
  lua require'plugins'
endif
