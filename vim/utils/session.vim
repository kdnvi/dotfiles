vim9script
def GetFilepath(): string
  const out = systemlist('git rev-parse --abbrev-ref HEAD 2>/dev/null')
  if v:shell_error != 0 || empty(out) || empty(out[0])
    return ''
  endif # returns empty as we want silent exit
  const branch = out[0]->trim()
  const hash = sha256($'{getcwd()}_{branch}')
  const dir = $'{$XDG_STATE_HOME}/vim/sessions'
  if !isdirectory(dir) | mkdir(dir, 'p') | endif
  return $'{dir}/{hash}.vim'
enddef

command! ClearSession {
  const f = GetFilepath()
  if empty(f) || !filereadable(f)
    throw 'no session found'
  elseif delete(f) != 0
    throw $'failed to remove session: {f}'
  endif
  echo $'removed session: {f}'
} # clear current session

# don't source session when opening specific file
if !argc()
  augroup session_management
    autocmd!
    autocmd BufWritePost * {
      const f = GetFilepath()
      if !empty(f) | execute $'mksession! {fnameescape(f)}' | endif
    }
    autocmd VimEnter * ++nested {
      const f = GetFilepath()
      if !empty(f) && filereadable(f) | execute $'source {fnameescape(f)}' | endif
    }
  augroup END
endif
defcompile
