vim.opt_local.formatprg = "clang-format"
if vim.fs.find("CMakeLists.txt", { upward = true, path = "." })[1] then
    vim.opt_local.errorformat = "%f:%l:%c: %m"
    vim.opt_local.makeprg = "cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug && cmake --build build --parallel"
end -- cmake
