local api = vim.api
local user_command = api.nvim_create_user_command
local map = vim.keymap.set
local fs = vim.fs
local fn = vim.fn
local setl = vim.opt_local
local cwd = vim.uv.cwd()

if fs.find("pom.xml", { upward = true, path = "." })[1] then
    setl.errorformat = "[ERROR] %f:[%l\\,%v] %m"
    setl.makeprg = "mvn compile"

    user_command("MvnTest", function(opts)
        local fpath = api.nvim_buf_get_name(0):sub(#cwd + 2) -- relative path
        local basename = fs.basename(fpath)
        local fname = basename:match("(.+)%.") or basename

        local is_test_file = string.match(fname, "[Tt]ests?$") or string.find(fpath, "/test/", 1, true)
        assert(is_test_file, "not a test file")

        -- walk up the directory tree to find pom.xml
        local pompath = fs.find("pom.xml", { upward = true, path = fs.dirname(fpath) })[1]
        local modpath = pompath and fs.dirname(pompath) or ""

        -- generate test command
        local height = math.floor(vim.o.lines * 0.37)
        local test_cmd = { "belowright " .. height .. "split | terminal mvn test -e -DskipTests=false" }
        table.insert(test_cmd, " -Dgroups=medium,small")
        table.insert(test_cmd, " -Dlogback.configurationFile=")
        table.insert(test_cmd, cwd)
        table.insert(test_cmd, "/logback-dev.xml")
        local config_path = string.format("%s/configuration.properties", cwd)
        if #modpath > 0 then
            local result = vim.system(
                { "mvn", "help:evaluate", "-Dexpression=project.artifactId", "-q", "-DforceStdout" },
                { cwd = modpath, text = true }
            ):wait()
            local module = vim.trim(result.stdout or "")
            assert(result.code == 0 and #module > 0, "failed to get module name")
            table.insert(test_cmd, " -pl :")
            table.insert(test_cmd, module)

            local mod_cp = string.format("%s/%s/configuration.properties", cwd, modpath)
            if vim.uv.fs_stat(mod_cp) then
                config_path = string.format("%s:%s", config_path, mod_cp)
            end -- module specific configuration.properties
        end     -- non-root module

        table.insert(test_cmd, " -Dic.configurationFile=")
        table.insert(test_cmd, config_path)

        -- extract test class name from current file
        local tdir_pattern = "/src/test/java/"
        local tdir_pos = string.find(fpath, tdir_pattern, 1, true)
        assert(tdir_pos, "could not extract test class name")

        local test_class = fpath:sub(tdir_pos + #tdir_pattern):gsub("/", "."):gsub("%.java$", "")
        table.insert(test_cmd, " -Dtest=")
        table.insert(test_cmd, test_class)

        local method_arg = (opts.args and vim.trim(opts.args))
        if #method_arg > 0 then
            table.insert(test_cmd, "\\#")
            table.insert(test_cmd, method_arg)
        end -- add -Dtest optional method name if specified

        -- bang = debug (:MvnTest! or :MvnTest! method)
        if opts.bang then
            table.insert(test_cmd,
                " -DargLine=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=localhost:5500")
        end -- checkout dap.configurations.java
        vim.cmd(table.concat(test_cmd))
        vim.cmd("normal! G")
    end, { nargs = "?", bang = true, desc = "run maven test (method); use ! to debug" })
end -- maven

-- jdb: thin wrapper for breakpoint management
local ns = api.nvim_create_namespace("jdb_bp")
_G._jdb = _G._jdb or { chan = nil, breakpoints = {} }
local jdb = _G._jdb

local function jdb_class_name()
    local fpath = api.nvim_buf_get_name(0)
    local class = fpath:match("/src/[^/]+/java/(.+)%.java$")
        or fpath:match("/src/(.+)%.java$")
    assert(class, "could not derive class name from path")
    return class:gsub("/", ".")
end

local function jdb_send(cmd)
    assert(jdb.chan, "jdb not running")
    fn.chansend(jdb.chan, cmd .. "\n")
end

local function jdb_attach()
    if jdb.chan then return end

    local host = fn.input("host: ", "localhost")
    if #host == 0 then return end
    local port = tonumber(fn.input("port: ", "5500"))
    if not port then return end

    local width = math.floor(vim.o.columns * 0.37)
    vim.cmd("belowright " .. width .. "vsplit new")
    jdb.chan = fn.jobstart(
        string.format("jdb -connect com.sun.jdi.SocketAttach:hostname=%s,port=%d", host, port), {
            term = true,
            on_exit = function()
                jdb.chan = nil
                for _, bp in pairs(jdb.breakpoints) do
                    api.nvim_buf_del_extmark(bp.buf, ns, bp.mark)
                end
                jdb.breakpoints = {}
            end,
        })
    vim.cmd("normal! G")
end

local function jdb_toggle_breakpoint()
    assert(jdb.chan, "jdb not running")

    local class = jdb_class_name()
    local line = api.nvim_win_get_cursor(0)[1]
    local key = class .. ":" .. line
    local buf = api.nvim_get_current_buf()

    if not jdb.breakpoints[key] then
        local mark_id = api.nvim_buf_set_extmark(buf, ns, line - 1, 0, {
            sign_text = "B",
            sign_hl_group = "DiagnosticError",
        })
        jdb.breakpoints[key] = { buf = buf, mark = mark_id }
        jdb_send("stop at " .. key)
    else
        api.nvim_buf_del_extmark(jdb.breakpoints[key].buf, ns, jdb.breakpoints[key].mark)
        jdb.breakpoints[key] = nil
        jdb_send("clear " .. key)
    end
end

user_command("Debug", jdb_attach, { nargs = 0, desc = "jdb attach" })
user_command("Bp", jdb_toggle_breakpoint, { nargs = 0, desc = "jdb toggle breakpoint" })
user_command("Dbc", function(opts) jdb_send(opts.args) end, { nargs = "+", desc = "run debug command" })

map({ "n", "v" }, "<Up>", [[:Dbc cont<CR>]], { buffer = 0 })
map({ "n", "v" }, "<Right>", [[:Dbc next<CR>]], { buffer = 0 })
map({ "n", "v" }, "<Down>", [[:Dbc step<CR>]], { buffer = 0 })
map({ "n", "v" }, "<Left>", [[:Dbc step up<CR>]], { buffer = 0 })
map("n", "<C-k>", [[:Dbc dump <C-r><C-w>]], { buffer = 0 })
map("v", "<C-k>", [["0y:Dbc dump <C-r>0]], { buffer = 0 })
