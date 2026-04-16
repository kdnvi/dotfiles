vim9script

if !empty(findfile('pom.xml', '.;'))
  setlocal errorformat=[ERROR]\ %f:[%l\\,%v]\ %m
  setlocal makeprg=mvn\ package\ -T\ 1C\ -am\ -DskipTests

  def RunTests(method_arg: string, bang: bool)
    var fpath = expand('%') # relative path
    if fpath !~# '\(/test/\|[Tt]ests\?\.java\)' | throw 'not a test file' | endif
    var config_path = $'{getcwd()}/configuration.properties'

    var pompath = findfile('pom.xml', expand('%:p:h') .. ';')
    var modpath = fnamemodify(pompath, ':h')
    var module_flag = ''
    if modpath != '.'
      var result = systemlist($'mvn -f {pompath} help:evaluate -Dexpression=project.artifactId -q -DforceStdout')
      var module = empty(result) ? '' : trim(result[0])
      if v:shell_error != 0 || empty(module) | throw 'failed to get module name' | endif
      module_flag = $'-pl :{module}'

      var modcpath = $'{getcwd()}/{modpath}/configuration.properties'
      if filereadable(modcpath)
        config_path = $'{config_path}:{modcpath}'
      endif
    endif
    var test_pattern = '/src/test/java/'
    var pattern_pos = stridx(fpath, test_pattern)
    if pattern_pos < 0 | throw 'could not extract test class name' | endif

    var test_class = fnamemodify(fpath, ':r')[pattern_pos + len(test_pattern) :]->substitute('/', '.', 'g')
    var test_target = empty(method_arg) ? test_class : $'{test_class}\#{method_arg}'
    var debug_flag = bang ? '-DargLine=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=localhost:5005' : ''
    var default_flag = $'-DskipTests=false -Dgroups=medium,small -Dlogback.configurationFile={getcwd()}/logback-dev.xml'
    execute $'!mvn test -e {default_flag} {module_flag} -Dic.configurationFile={config_path} -Dtest={test_target} {debug_flag}'
  enddef

  command! -buffer -nargs=? -bang RunTests RunTests(<q-args>, <bang>false)
endif

def BreakpointCopy()
  var fpath = expand('%:p')
  var class = matchstr(fpath, '/src/[^/]\+/java/\zs.\+\ze\.java$')
  if empty(class)
    class = matchstr(fpath, '/src/\zs.\+\ze\.java$')
  endif
  if empty(class) | throw 'could not derive class name from path' | endif
  class = class->substitute('/', '.', 'g')
  var bp = $'stop at {class}:{line(".")}'
  setreg('+', bp)
  echo bp
enddef
command! -buffer Breakpoint BreakpointCopy()

defcompile
# vim: sw=2 ts=2 sts=2
