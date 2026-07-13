set nocompatible encoding=utf-8
set tabstop=4 shiftwidth=0 expandtab
set nomodeline noswapfile undofile
set ignorecase smartcase updatetime=512
set wildoptions=pum,tagfile,fuzzy
set incsearch hlsearch
set number relativenumber
set title showmatch splitright list
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
autocmd FileType help,qf,checkhealth,dap-float nn <buffer> q <Cmd>bd<CR>
autocmd FileType qf setl nonumber norelativenumber

if has('nvim')
  autocmd TextYankPost * silent! lua vim.hl.on_yank()
  autocmd FileType vim setl tabstop=2

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

  " unload redundant providers
  let g:loaded_node_provider = 0
  let g:loaded_perl_provider = 0
  let g:loaded_python3_provider = 0
  let g:loaded_ruby_provider = 0
  let g:loaded_matchit = 1
  set cursorline completeopt+=menuone,noselect
  colorscheme monokai

  " :find command should search files
  func! s:findfiles(cmdarg, _cmdcomp) abort
    let l:out = systemlist('rg --files -. -L -S -g=!.git 2>/dev/null')
    if v:shell_error != 0 | return [] | endif
    return empty(a:cmdarg) ? l:out : matchfuzzy(l:out, a:cmdarg)
  endfunc
  set findfunc=s:findfiles
  nnoremap <Space>f :find 
  nnoremap <Space>F :find <C-r><C-w><C-z>

  " example diff hunk (git diff -U0 HEAD):
  "   diff --git a/nvim/init.vim b/nvim/init.vim
  "   --- a/nvim/init.vim
  "   +++ b/nvim/init.vim
  "   @@ -37,0 +38 @@
  "   +autocmd FileType qf setl nonumber norelativenumber
  " -> nvim/init.vim<Tab>38<Tab>@@ -37,0 +38 @@
  func! s:gitfiles() abort
    let l:files = []
    let l:root = systemlist('git rev-parse --show-toplevel 2>/dev/null')->get(0, '')
    if empty(l:root) | echo 'not a git repo' | return | endif

    " awk reads the diff stream line by line:
    "   /^diff --git/  starts a new file; $4 is the b/ path, saved in f
    "   sub("^b/","",f) removes the diff prefix, leaving a repo-relative path
    "   f && /^@@/     handles only the first hunk header after a saved file path
    "   split($3,a,",") takes the + side of the hunk, e.g. "+38" or "+75,23"
    "   sub(/^\+/,"",a[1]) removes the leading +, leaving the target line number
    "   print ...      emits path<Tab>line<Tab>hunk-header for setloclist()
    "   f=""           clears the file path so later hunks for the same file are skipped
    let l:awk = '/^diff --git/{f=$4; sub("^b/","",f)} f && /^@@/{split($3,a,","); sub(/^\+/,"",a[1]); print f "\t" a[1] "\t" $0; f=""}'
    for l:l in systemlist('git diff -U0 HEAD 2>/dev/null | awk ' . shellescape(l:awk))
      let l:p = split(l:l, "\t")
      call add(l:files, {'filename': l:root . '/' . l:p[0], 'lnum': str2nr(l:p[1]), 'text': join(l:p[2:], "\t")})
    endfor

    " untracked files are absent from git diff, list them at line 1
    for l:f in systemlist('git ls-files --full-name -o --exclude-standard 2>/dev/null')
      call add(l:files, {'filename': l:root . '/' . l:f, 'lnum': 1, 'text': l:f})
    endfor
    if empty(l:files) | echo 'no changes' | return | endif
    call setloclist(0, l:files, 'r') | lopen
  endfunc
  command! GFiles call <SID>gitfiles()
  nnoremap <Space>s <Cmd>GFiles<CR>

  " load lua stuff
  lua require'utils'
  lua require'lspc'
  lua require'sessionize'
  lua require'bundle'
endif
