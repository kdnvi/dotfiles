vim9script
setl formatexpr=lsp#lsp#FormatExpr()

if !empty(findfile('pom.xml', '.;'))
  setl errorformat=[ERROR]\ %f:[%l\\,%v]\ %m
  setl makeprg=mvn\ package\ -T\ 1C\ -am\ -DskipTests

  def RunTests(arg: string, bang: bool)
    const file_path = expand('%') # relative path
    if file_path !~# '\(/test/\|[Tt]ests\?\.java\)' | throw 'not a test file' | endif
    var config_path = $'{getcwd()}/configuration.properties'

    var mod_flag = ''
    const pom_path = findfile('pom.xml', $'{expand("%:p:h")};')
    const mod_path = fnamemodify(pom_path, ':h')
    if !empty(mod_path) && mod_path != '.'
      const out = systemlist($'mvn -f {pom_path} help:evaluate -Dexpression=project.artifactId -q -DforceStdout 2>/dev/null')
      const mod = empty(out) ? '' : trim(out[0])
      if v:shell_error != 0 || empty(mod) | throw 'failed to get module name' | endif
      mod_flag = $'-pl :{mod}'

      const mod_conf_path = $'{getcwd()}/{mod_path}/configuration.properties'
      if filereadable(mod_conf_path) | config_path = $'{config_path}:{mod_conf_path}' | endif
    endif
    const test_pattern = '/src/test/java/'
    const pattern_pos = stridx(file_path, test_pattern)
    if pattern_pos < 0 | throw 'could not extract test class name' | endif

    const test_class = fnamemodify(file_path, ':r')[pattern_pos + len(test_pattern) :]->substitute('/', '.', 'g')
    const test_target = empty(arg) ? test_class : $'{test_class}\#{arg}'
    const debug_flag = bang ? '-DargLine=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=localhost:5005' : ''
    const default_flag = $'-DskipTests=false -Dgroups=medium,small -Dlogback.configurationFile={getcwd()}/logback-dev.xml'
    execute $'terminal mvn test -e {default_flag} {mod_flag} -Dic.configurationFile={config_path} -Dtest={test_target} {debug_flag}'
  enddef

  command! -buffer -nargs=? -bang RunTests RunTests(<q-args>, <bang>false)
endif

def Breakpoint()
  const file_path = expand('%:p')
  var class = matchstr(file_path, '/src/[^/]\+/java/\zs.\+\ze\.java$')
  if empty(class) | class = matchstr(file_path, '/src/\zs.\+\ze\.java$') | endif
  if empty(class) | throw 'could not derive class name from path' | endif
  class = class->substitute('/', '.', 'g')
  const bp = $'stop at {class}:{line(".")}'
  setreg('+', bp)
  echo bp
enddef
command! -buffer Bp Breakpoint()
defcompile
