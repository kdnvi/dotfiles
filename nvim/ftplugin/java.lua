local function extract_class_name(file_path)
    local class = file_path:match("/src/[^/]+/java/(.+)%.java$") or file_path:match("/src/(.+)%.java$")
    assert(class, "could not derive fully qualified class name from path")
    return class:gsub("/", ".")
end -- extract FQCN

if vim.fs.find("pom.xml", {upward=true, stop=vim.fs.dirname(vim.uv.cwd())})[1] then
    vim.opt_local.errorformat = "[ERROR] %f:[%l\\,%v] %m"
    vim.opt_local.makeprg = "mvn package -T 1C -am -DskipTests"

    vim.api.nvim_buf_create_user_command(0, "RunTests", function(opts)
        local file_path = vim.fs.relpath(vim.uv.cwd(), vim.api.nvim_buf_get_name(0))
        assert(vim.regex([[\(/test/\|[Tt]ests\?\.java\)]]):match_str(file_path), "not a test file")

        -- generate test command
        local test_cmd = {"terminal mvn test -e -DskipTests=false"}
        table.insert(test_cmd, " -Dgroups=medium,small")
        table.insert(test_cmd, " -Dlogback.configurationFile=")
        table.insert(test_cmd, vim.uv.cwd())
        table.insert(test_cmd, "/logback-dev.xml")

        -- walk up the directory tree to find pom.xml
        local pom_path = vim.fs.find("pom.xml", {upward=true, path=vim.fs.dirname(file_path)})[1]
        local mod_path = vim.fs.dirname(pom_path)
        local config_path = vim.uv.cwd() .. "/configuration.properties"

        if #mod_path > 0 then
            local out = vim.system(
                {"mvn", "-f", pom_path, "help:evaluate", "-Dexpression=project.artifactId", "-q", "-DforceStdout"},
                {stdout=true}
            ):wait()
            local mod = vim.trim(out.stdout or "")
            assert(out.code==0 and #mod>0, "failed to get module name")
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
        local test_class = extract_class_name(file_path)
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
    end, {nargs="?", bang=true, desc="run maven test (method); use ! to debug"})
end -- maven

-- set -x JDK_JAVA_OPTIONS '-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=localhost:5005'
-- to turn on debug agent, set suspend=y to wait for DAP to attach
local dap = require("dap")
dap.adapters.java = function(callback)
    local client = vim.lsp.get_clients({name="jdtls"})[1]
    assert(client, "must have running jdtls client")
    local bufnr = vim.api.nvim_get_current_buf()

    client:request("workspace/executeCommand", {command="vscode.java.startDebugSession"}, function(err, port)
        assert(not err, vim.inspect(err))
        callback({type="server", host="localhost", port=port})
    end, bufnr)
end -- use `set -e JDK_JAVA_OPTIONS` to erase the env variable

-- project specific configs are located in launch.json
-- these are configs for general use cases only
dap.configurations.java = {{
    name="Debug (Attach) - Local",
    type="java", request="attach", timeout=5000,
    -- projectName=function() return vim.fn.input("project_name: ") end,
    hostName="localhost",
    port=function() return tonumber(vim.fn.input("port: ", "5005")) or 5005 end,
}, {
    name="Debug (Attach) - Remote",
    type="java", request="attach", timeout=30000,
    -- projectName=function() return vim.fn.input("project_name: ") end,
    hostName=function() return vim.fn.input("remote_host: ") end,
    port=function() return tonumber(vim.fn.input("port: ", "5005")) or 5005 end
}}

-- threads widget also contains frames
local widgets = require("dap.ui.widgets")
vim.keymap.set("n", "<C-s>", widgets.sidebar(widgets.scopes, {width=65}).toggle)
vim.keymap.set("n", "<C-h>", function() widgets.cursor_float(widgets.threads) end)
vim.keymap.set("n", "<C-w>b", dap.toggle_breakpoint, {buffer=0})
vim.keymap.set("n", "<Up>", dap.continue)
vim.keymap.set("n", "<Down>", dap.step_over)
vim.keymap.set("n", "<Right>", dap.step_into)
vim.keymap.set("n", "<Left>", dap.step_out)
