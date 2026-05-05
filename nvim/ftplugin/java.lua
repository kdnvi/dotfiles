local golden_ratio = 0.38
if vim.fs.find("pom.xml", { upward = true, path = "." })[1] then
    vim.opt_local.errorformat = "[ERROR] %f:[%l\\,%v] %m"
    vim.opt_local.makeprg = "mvn package -T 1C -am -DskipTests"

    vim.api.nvim_buf_create_user_command(0, "RunTests", function(opts)
        local file_path = vim.api.nvim_buf_get_name(0):sub(#vim.uv.cwd() + 2) -- relative path
        assert(vim.regex([[\(/test/\|[Tt]ests\?\.java\)]]):match_str(file_path), "not a test file")

        -- generate test command
        local height = math.floor(vim.o.lines * golden_ratio)
        local test_cmd = { "belowright " .. height .. "split | terminal mvn test -e -DskipTests=false" }
        table.insert(test_cmd, " -Dgroups=medium,small")
        table.insert(test_cmd, " -Dlogback.configurationFile=")
        table.insert(test_cmd, vim.uv.cwd())
        table.insert(test_cmd, "/logback-dev.xml")

        -- walk up the directory tree to find pom.xml
        local pom_path = vim.fn.findfile("pom.xml", vim.fn.expand("%:p:h") .. ";")
        local mod_path = vim.fn.fnamemodify(pom_path, ":h")
        local config_path = vim.uv.cwd() .. "/configuration.properties"

        if #mod_path > 0 then
            local out = vim.system(
                { "mvn", "-f", pom_path, "help:evaluate", "-Dexpression=project.artifactId", "-q", "-DforceStdout" },
                { stdout = true }
            ):wait()
            local mod = vim.trim(out.stdout or "")
            assert(out.code == 0 and #mod > 0, "failed to get module name")
            table.insert(test_cmd, " -pl :")
            table.insert(test_cmd, mod)

            local mod_conf_path = string.format("%s/%s/configuration.properties", vim.uv.cwd(), mod_path)
            if vim.uv.fs_stat(mod_conf_path) then
                config_path = string.format("%s:%s", config_path, mod_conf_path)
            end -- module specific configuration.properties
        end
        table.insert(test_cmd, " -Dic.configurationFile=")
        table.insert(test_cmd, config_path)

        -- extract test class name from current file
        local dir_pattern = "/src/test/java/"
        local pos = string.find(file_path, dir_pattern, 1, true)
        assert(pos, "could not extract test class name")

        local test_class = file_path:sub(pos + #dir_pattern):gsub("/", "."):gsub("%.java$", "")
        table.insert(test_cmd, " -Dtest=")
        table.insert(test_cmd, test_class)

        local method_name = vim.trim(opts.args or "")
        if #method_name > 0 then
            table.insert(test_cmd, "\\#")
            table.insert(test_cmd, method_name)
        end -- add -Dtest optional method name if specified

        if opts.bang then
            table.insert(test_cmd, " -DargLine=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=localhost:5005")
        end -- bang = debug (:RunTests! or :RunTests! method)
        vim.cmd(table.concat(test_cmd))
        vim.cmd("normal! G")
    end, { nargs = "?", bang = true, desc = "run maven test (method); use ! to debug" })
end -- maven

local ns = vim.api.nvim_create_namespace("jdb_bp")
_G._jdb = _G._jdb or { chan = nil, breakpoints = {} }
local jdb = _G._jdb

local function jdb_attach()
    if jdb.chan then return end

    local host = vim.fn.input("host: ", "localhost")
    assert(host, "host must be specified")
    local port = tonumber(vim.fn.input("port: ", "5005"))
    assert(port, "port must be specified")

    local width = math.floor(vim.o.columns * golden_ratio)
    vim.cmd("belowright " .. width .. "vsplit new")
    jdb.chan = vim.fn.jobstart(
        { "jdb", "-connect", string.format("com.sun.jdi.SocketAttach:hostname=%s,port=%d", host, port) },
        { term = true, on_exit = function()
            jdb.chan = nil
            for _, bp in pairs(jdb.breakpoints) do
                vim.api.nvim_buf_del_extmark(bp.buf, ns, bp.mark)
            end
            jdb.breakpoints = {}
        end })

    vim.cmd("normal! G")
end -- simple jdb wrapper

local function jdb_class_name()
    local file_path = vim.api.nvim_buf_get_name(0)
    local class = file_path:match("/src/[^/]+/java/(.+)%.java$")
        or file_path:match("/src/(.+)%.java$")
    assert(class, "could not derive class name from path")
    return class:gsub("/", ".")
end

local function jdb_send(cmd)
    assert(jdb.chan, "jdb not running")
    vim.fn.chansend(jdb.chan, cmd .. "\n")
end

local function jdb_toggle_breakpoint()
    assert(jdb.chan, "jdb not running")

    local class = jdb_class_name()
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local key = class .. ":" .. line
    local buf = vim.api.nvim_get_current_buf()

    if not jdb.breakpoints[key] then
        local mark_id = vim.api.nvim_buf_set_extmark(buf, ns, line - 1, 0, {
            sign_text = "B",
            sign_hl_group = "DiagnosticError",
        })
        jdb.breakpoints[key] = { buf = buf, mark = mark_id }
        jdb_send("stop at " .. key)
        return
    end

    vim.api.nvim_buf_del_extmark(jdb.breakpoints[key].buf, ns, jdb.breakpoints[key].mark)
    jdb.breakpoints[key] = nil
    jdb_send("clear " .. key)
end

vim.api.nvim_buf_create_user_command(0, "Debug", jdb_attach, { nargs = 0, desc = "start debugger" })
vim.api.nvim_buf_create_user_command(0, "Bp", jdb_toggle_breakpoint, { nargs = 0, desc = "toggle breakpoint" })
vim.api.nvim_buf_create_user_command(0, "Jdb", function(opts) jdb_send(opts.args) end, { nargs = "+", desc = "run jdb command" })

vim.keymap.set({ "n", "v" }, "<Up>", [[:Jdb cont<CR>]], { buffer = 0 })
vim.keymap.set({ "n", "v" }, "<Right>", [[:Jdb next<CR>]], { buffer = 0 })
vim.keymap.set({ "n", "v" }, "<Down>", [[:Jdb step<CR>]], { buffer = 0 })
vim.keymap.set({ "n", "v" }, "<Left>", [[:Jdb step up<CR>]], { buffer = 0 })
vim.keymap.set("n", "<Space>d", [[:Jdb dump <C-r><C-w>]], { buffer = 0 })
vim.keymap.set("v", "<Space>d", [["0y:Jdb dump <C-r>0]], { buffer = 0 })
