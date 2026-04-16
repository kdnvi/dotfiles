vim9script

setlocal formatprg=clang-format

if !empty(findfile('CMakeLists.txt', '.;'))
  setlocal errorformat=%f:%l:%c:\ %m
  setlocal makeprg=cmake\ -S\ .\ -B\ build\ -DCMAKE_BUILD_TYPE=Debug\ &&\ cmake\ --build\ build\ --parallel
endif
