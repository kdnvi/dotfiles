vim9script
if !empty(findfile('pom.xml', '.;'))
  setl makeprg=mvn\ package\ -DskipTests\ -T\ 1C\ -am
  setl errorformat=[ERROR]\ %f:[%l\\,%c]\ %m
endif

def GetFqcn()
  const class = matchstr(expand('%'), '\v(^|.*/)src/([^/]+/java/)?\zs.+\ze\.java$')
  if empty(class) | throw 'could not derive fully qualified class name from path' | endif
  const name = substitute(class, '/', '.', 'g')
  const @+ = name | echo name
enddef

command! -buffer -nargs=0 Fqcn GetFqcn()
nmap <buffer> <Space>J <Cmd>Fqcn<CR>
defcompile
