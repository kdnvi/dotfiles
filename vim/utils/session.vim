vim9script

def GetFilepath(): string
  const result = systemlist('git rev-parse --abbrev-ref HEAD')
  if v:shell_error != 0 || empty(result) || empty(result[0])
    return ''
  endif # returns empty as we want silent exit
  const branch = result[0]->trim()
  const hash = sha256($'{getcwd()}_{branch}')
  const sessions_dir = $'{$XDG_STATE_HOME}/vim/sessions'
  if !isdirectory(sessions_dir)
    mkdir(sessions_dir, 'p')
  endif # first run only
  return $'{sessions_dir}/{hash}.vim'
enddef

command! ClearSession {
  const sfile = GetFilepath()
  if empty(sfile) || !filereadable(sfile)
    echoerr 'no session found'
  elseif delete(sfile) != 0
    echoerr $'failed to remove session file: {sfile}'
  else
    echo $'removed session file: {sfile}'
  endif
} # clear current repo session

# don't do sessionize stuff if opening specific files
if !argc()
  augroup session_management
    autocmd!
    autocmd BufWritePost * {
      const sfile = GetFilepath()
      if !empty(sfile)
        execute $'mksession! {fnameescape(sfile)}'
      endif
    }
    autocmd VimEnter * ++nested {
      const sfile = GetFilepath()
      if !empty(sfile) && filereadable(sfile)
        execute $'source {fnameescape(sfile)}'
      endif
    }
  augroup END
endif

defcompile
