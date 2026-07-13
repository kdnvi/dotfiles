local setl = vim.opt_local
setl.formatprg = "clang-format"

if vim.fs.find("CMakeLists.txt", { upward = true, path = "." })[1] then
    setl.errorformat = "%f:%l:%c: %m"
    setl.makeprg = "cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug && cmake --build build --parallel"
end -- cmake
