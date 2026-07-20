setl tabstop=2

if !empty(findfile('CMakeLists.txt', '.;'))
  setl makeprg=cmake\ -S\ .\ -B\ build\ &&\ cmake\ --build\ build
endif
