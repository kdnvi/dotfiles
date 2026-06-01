if vim.fs.find('pom.xml', {upward=true, stop=vim.fs.dirname(vim.uv.cwd())})[1] then
    vim.opt_local.errorformat = [[[ERROR] %f:[%l\,%v] %m]]
    vim.opt_local.makeprg = 'mvn package -DskipTests -T 1C -am'
end -- maven

vim.api.nvim_buf_create_user_command(0, 'Fqcn', function()
    local file_path = vim.fs.relpath(vim.uv.cwd(), vim.api.nvim_buf_get_name(0))
    local class = file_path:match[[/src/[^/]+/java/(.+)%.java$]]
        or file_path:match[[/src/(.+)%.java$]]
    assert(class, 'could not derive fully qualified class name from path')
    local class_name = class:gsub('/', '.')
    vim.fn.setreg('+', class_name)
    vim.notify(class_name, vim.log.levels.INFO)
end, {nargs=0, desc='extract fully qualified class name'})
vim.keymap.set('n', '<Space>jc', '<Cmd>Fqcn<CR>', {buffer=0, desc='copy java fqcn'})
