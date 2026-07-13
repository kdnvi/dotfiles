set nocompatible encoding=utf-8
set incsearch hlsearch autoindent autoread
set nomodeline noswapfile title
set tabstop=4 shiftwidth=0 expandtab
set ignorecase smartcase updatetime=512
set hidden laststatus=2 belloff=all
set mouse=nvi mousemodel=popup_setpos
set showmatch splitright list
set wildoptions=pum,tagfile,fuzzy
set listchars=tab:>\ ,trail:-,nbsp:+
let &showbreak = '+++ '
syntax enable

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

" open the quickfix window whenever a qf command is executed
autocmd QuickFixCmdPost [^l]* cwindow
autocmd FileType help,qf,checkhealth nn <buffer> q <Cmd>bd<CR>

if has('nvim')
  autocmd TextYankPost * silent! lua vim.hl.on_yank()
  autocmd FileType * silent! lua vim.treesitter.stop()
  autocmd FileType vim setl tabstop=2

  " quickly copy file name/path
  nn <Space>n <Cmd>let @+=expand('%:t')<Bar>echo 'filename yanked'<CR>
  nn <Space>N <Cmd>let @+=expand('%:p')<Bar>echo 'filepath yanked'<CR>

  " unload redundant providers
  let g:loaded_node_provider = 0
  let g:loaded_perl_provider = 0
  let g:loaded_python3_provider = 0
  let g:loaded_ruby_provider = 0
  let g:loaded_matchit = 1
  set undofile completeopt+=menuone,noselect
  set inccommand=split cursorline
  colorscheme unokai

  " :find command should search files
  func! s:findfiles(cmdarg, _cmdcomp) abort
    let l:out = systemlist('rg --files -. -L -S -g=!.git 2>/dev/null')
    if v:shell_error != 0 | return [] | endif
    return empty(a:cmdarg) ? l:out : matchfuzzy(l:out, a:cmdarg)
  endfunc
  set findfunc=s:findfiles
  nnoremap <Space>f :find 
  nnoremap <Space>F :find <C-r><C-w><C-z>

  " yank/paste to/from system clipboard
  " all motions work the same as normal [y]
  nnoremap <Space>y "+y
  vnoremap <Space>y "+y
  nnoremap <Space>p "+p
  vnoremap <Space>p "+p
  nnoremap <Space>P "+P

  " browse git modified/untracked files
  func! s:gitfiles() abort
    let l:out = systemlist('git ls-files -m -o --exclude-standard 2>/dev/null')
    if v:shell_error != 0 || empty(l:out) | echo 'no changes' | return | endif
    let l:files = map(l:out, {_, f -> {'filename': f, 'lnum': 1, 'text': fnamemodify(f, ':t')}})
    call setloclist(0, l:files, 'r') | lopen
  endfunc
  command! GFiles call <SID>gitfiles()
  nnoremap <Space>s <Cmd>GFiles<CR>

  " load lua stuff
  lua require'utils'
  lua require'lspc'
  lua require'bundle.diffsign'
  lua require'sessionize'
endif
