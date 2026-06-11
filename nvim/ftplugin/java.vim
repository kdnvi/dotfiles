if !empty(findfile('pom.xml', '.;'))
  setl makeprg=mvn\ package\ -DskipTests\ -T\ 1C\ -am
  setl errorformat=[ERROR]\ %f:[%l\\,%c]\ %m
endi

func! s:fqcn() abort
  let l:class = matchstr(expand('%'), '\v(^|.*/)src/([^/]+/java/)?\zs.+\ze\.java$')
  if empty(l:class) | throw 'could not derive fully qualified class name from path' | endi
  let l:name = substitute(l:class, '/', '.', 'g')
  let @+ = l:name | echo l:name
endf

command! -buffer -nargs=0 Fqcn call <SID>fqcn()
nmap <buffer> <Space>jc <Cmd>Fqcn<CR>
