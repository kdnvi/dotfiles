local function extract_class_name(file_path)
    local class = file_path:match('/src/[^/]+/java/(.+)%.java$') or file_path:match('/src/(.+)%.java$')
    assert(class, 'could not derive fully qualified class name from path')
    return class:gsub('/', '.')
end -- extract FQCN

if vim.fs.find('pom.xml', {upward=true, stop=vim.fs.dirname(vim.uv.cwd())})[1] then
    vim.opt_local.errorformat = '[ERROR] %f:[%l\\,%v] %m'
    vim.opt_local.makeprg = 'mvn package -T 1C -am -DskipTests'

    vim.api.nvim_buf_create_user_command(0, 'RunTests', function(opts)
        local file_path = vim.fs.relpath(vim.uv.cwd(), vim.api.nvim_buf_get_name(0))
        assert(vim.regex([[\(/test/\|[Tt]ests\?\.java\)]]):match_str(file_path), 'not a test file')

        -- generate test command
        local height = math.floor(vim.o.lines*0.2)
        local test_cmd = {'belowright '..height..'split | terminal mvn test -e -DskipTests=false'}
        table.insert(test_cmd, ' -Dgroups=medium,small')
        table.insert(test_cmd, ' -Dlogback.configurationFile=')
        table.insert(test_cmd, vim.uv.cwd())
        table.insert(test_cmd, '/logback-dev.xml')

        -- walk up the directory tree to find pom.xml
        local pom_path = vim.fs.find('pom.xml', {upward=true, path=vim.fs.dirname(file_path)})[1]
        local mod_path = vim.fs.dirname(pom_path)
        local config_path = vim.uv.cwd() .. '/configuration.properties'

        if #mod_path > 0 then
            local out = vim.system(
                {'mvn', '-f', pom_path, 'help:evaluate', '-Dexpression=project.artifactId', '-q', '-DforceStdout'},
                {stdout=true}
            ):wait()
            local mod = vim.trim(out.stdout or '')
            assert(out.code==0 and #mod>0, 'failed to get module name')
            table.insert(test_cmd, ' -pl :')
            table.insert(test_cmd, mod)

            local mod_conf_path = string.format('%s/%s/configuration.properties', vim.uv.cwd(), mod_path)
            if vim.uv.fs_stat(mod_conf_path) then
                config_path = string.format('%s:%s', config_path, mod_conf_path)
            end -- module specific configuration.properties
        end
        table.insert(test_cmd, ' -Dic.configurationFile=')
        table.insert(test_cmd, config_path)

        -- extract test class name from current file
        local test_class = extract_class_name(file_path)
        table.insert(test_cmd, ' -Dtest=')
        table.insert(test_cmd, test_class)

        local method_name = vim.trim(opts.args or '')
        if #method_name > 0 then
            table.insert(test_cmd, '\\#')
            table.insert(test_cmd, method_name)
        end -- add -Dtest optional method name if specified

        if opts.bang then
            table.insert(test_cmd, ' -DargLine=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=localhost:5005')
        end -- bang = debug (:RunTests! or :RunTests! method)
        vim.cmd(table.concat(test_cmd))
        vim.cmd('normal! G')
    end, {nargs='?', bang=true, desc='run maven test (method); use ! to debug'})
end -- maven

local ns = vim.api.nvim_create_namespace('jdb_bp')
_G.jdb_ctx = _G.jdb_ctx or {chan=nil, breakpoints={}, ready=false}

local function jdb_send(cmd)
    assert(_G.jdb_ctx.chan, 'jdb not running')
    vim.api.nvim_chan_send(_G.jdb_ctx.chan, cmd..'\n')
end

local function clear_breakpoints()
    assert(#_G.jdb_ctx.breakpoints==0, 'no active breakpoint')
    for k, v in pairs(_G.jdb_ctx.breakpoints) do
        if _G.jdb_ctx.chan then jdb_send('clear '..k) end
        vim.api.nvim_buf_del_extmark(v.buf, ns, v.mark)
    end
    _G.jdb_ctx.breakpoints = {}
    vim.notify('clear all breakpoints', vim.log.levels.INFO)
end

local function toggle_breakpoint()
    assert(_G.jdb_ctx.chan, 'jdb not running')

    local class = extract_class_name(vim.api.nvim_buf_get_name(0))
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local key = class .. ':' .. line
    local bufnr = vim.api.nvim_get_current_buf()

    if not _G.jdb_ctx.breakpoints[key] then
        local mark_id = vim.api.nvim_buf_set_extmark(bufnr, ns, line-1, 0, {
            sign_text='b*', sign_hl_group='ErrorMsg'
        })
        _G.jdb_ctx.breakpoints[key] = {buf=bufnr, mark=mark_id}
        jdb_send('stop at '..key)
        return
    end

    vim.api.nvim_buf_del_extmark(_G.jdb_ctx.breakpoints[key].buf, ns, _G.jdb_ctx.breakpoints[key].mark)
    _G.jdb_ctx.breakpoints[key] = nil
    jdb_send('clear '..key)
end

local function configure_jdb()
    if _G.jdb_ctx.ready then
        _G.jdb_ctx.chan = nil
        clear_breakpoints()

        vim.api.nvim_del_user_command('Jdb')
        vim.api.nvim_del_user_command('Bp')
        vim.api.nvim_del_user_command('ClearBps')

        vim.keymap.del({'n', 'v'}, '<Up>')
        vim.keymap.del({'n', 'v'}, '<Right>')
        vim.keymap.del({'n', 'v'}, '<Down>')
        vim.keymap.del({'n', 'v'}, '<Left>')
        vim.keymap.del('n', '<Space>d')
        vim.keymap.del('v', '<Space>d')

        _G.jdb_ctx.ready = false
    else
        vim.api.nvim_create_user_command('Jdb', function(opts) jdb_send(opts.args) end, {nargs='+', desc='run jdb command'})
        vim.api.nvim_create_user_command('Bp', toggle_breakpoint, {nargs=0, desc='toggle breakpoint'})
        vim.api.nvim_create_user_command('ClearBps', clear_breakpoints, {nargs=0, desc='clear breakpoints'})

        vim.keymap.set({'n', 'v'}, '<Up>', [[<Cmd>Jdb cont<CR>]])
        vim.keymap.set({'n', 'v'}, '<Right>', [[<Cmd>Jdb next<CR>]])
        vim.keymap.set({'n', 'v'}, '<Down>', [[<Cmd>Jdb step<CR>]])
        vim.keymap.set({'n', 'v'}, '<Left>', [[<Cmd>Jdb step up<CR>]])
        vim.keymap.set('n', '<Space>d', [[:Jdb dump <C-r><C-w>]])
        vim.keymap.set('v', '<Space>d', [["0y:Jdb dump <C-r>0]])

        _G.jdb_ctx.ready = true
    end
end -- if ready, del cmds/keymaps; otherwise, create

local function jdb_attach()
    if _G.jdb_ctx.chan then return end

    local host = vim.fn.input('host: ', 'localhost')
    assert(host, 'host must be specified')
    local port = tonumber(vim.fn.input('port: ', '5005'))
    assert(port, 'port must be specified')

    configure_jdb()
    local width = math.floor(vim.o.columns*0.5)
    vim.cmd('belowright '..width..'vsplit new')

    _G.jdb_ctx.chan = vim.fn.jobstart({
        'jdb', '-connect', string.format('com.sun.jdi.SocketAttach:hostname=%s,port=%d', host, port)
    }, {on_exit=function() configure_jdb() end, term=true})
    vim.cmd('normal! G')
end -- simple jdb wrapper
vim.api.nvim_buf_create_user_command(0, 'Debug', jdb_attach, {nargs=0, desc='start debugger'})
