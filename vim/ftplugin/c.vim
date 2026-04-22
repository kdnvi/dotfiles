setl formatprg=clang-format
if !empty(findfile('CMakeLists.txt', '.;'))
  setl errorformat=%f:%l:%c:\ %m
  setl makeprg=cmake\ -S\ .\ -B\ build\ -DCMAKE_BUILD_TYPE=Debug\ &&\ cmake\ --build\ build\ --parallel
endif
