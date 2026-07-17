setl colorcolumn=100
if !empty(findfile('pom.xml', '.;'))
  setl makeprg=mvn\ package\ -DskipTests\ -T\ 1C\ -am
  setl errorformat=[ERROR]\ %f:[%l\\,%c]\ %m
endif

func! s:fqcn() abort
  let l:class = matchstr(expand('%'), '\v(^|.*/)src/([^/]+/java/)?\zs.+\ze\.java$')
  if empty(l:class) | throw 'could not derive fully qualified class name from path' | endif
  let l:name = substitute(l:class, '/', '.', 'g')
  let @+ = l:name | echo l:name
endfunc

command! -buffer -nargs=0 Fqcn call <SID>fqcn()
nmap <buffer> <leader>J <Cmd>Fqcn<CR>
