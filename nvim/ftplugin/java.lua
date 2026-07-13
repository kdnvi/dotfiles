local setl = vim.opt_local
local fs = vim.fs
local api = vim.api
local cwd = vim.uv.cwd()

if fs.find("pom.xml", { upward = true, path = "." })[1] then
    setl.errorformat = "[ERROR] %f:[%l\\,%v] %m"
    setl.makeprg = "mvn compile"

    api.nvim_create_user_command("MvnTest", function(opts)
        local fpath = api.nvim_buf_get_name(0):sub(#cwd + 2) -- relative path
        local basename = fs.basename(fpath)
        local fname = basename:match("(.+)%.") or basename

        local is_test_file = string.match(fname, "[Tt]ests?$") or string.find(fpath, "/test/", 1, true)
        assert(is_test_file, "not a test file")

        -- walk up the directory tree to find pom.xml
        local pompath = fs.find("pom.xml", { upward = true, path = fs.dirname(fpath) })[1]
        local modpath = pompath and fs.dirname(pompath) or ""

        -- generate test command
        local test_cmd = { "terminal mvn test -e -DskipTests=false" }
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
        end -- non-root module

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
            table.insert(test_cmd, " -DargLine=-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=localhost:5500")
        end -- checkout dap.configurations.java
        vim.cmd(table.concat(test_cmd))
    end, { nargs = "?", bang = true, desc = "run maven test (method); use ! to debug" })
end -- maven
