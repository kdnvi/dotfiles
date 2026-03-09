local api = vim.api
local ns = api.nvim_create_namespace("gitdiff")
local signs = {
    add    = { text = "+", hl = "DiffAdd" },
    change = { text = "~", hl = "DiffChange" },
    delete = { text = "-", hl = "DiffDelete" }
}

local function update_sign(event)
    local buf = event.buf
    local name = api.nvim_buf_get_name(buf)
    if not api.nvim_buf_is_valid(buf) or #name == 0 then return end

    local cwd = vim.uv.cwd()
    local path = name:sub(1, #cwd) == cwd and name:sub(#cwd + 2) or name

    vim.system({ "git", "diff", "--no-ext-diff", "-U0", "--", path }, { text = true }, function(result)
        vim.schedule(function()
            if not api.nvim_buf_is_valid(buf) then return end
            api.nvim_buf_clear_namespace(buf, ns, 0, -1)
            if result.code ~= 0 then return end

            local last = api.nvim_buf_line_count(buf) - 1
            for line in result.stdout:gmatch("[^\n]+") do
                local _, old_n, new_s, new_n = line:match("^@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@")
                if not new_s then goto continue end

                old_n = tonumber(old_n) or 1
                new_s = tonumber(new_s)
                new_n = tonumber(new_n) or 1

                local sign = (new_n == 0 and signs.delete) or (old_n == 0 and signs.add) or signs.change
                local from = new_n == 0 and new_s - 1 or new_s
                local to = from + math.max(new_n, 1) - 1

                for row = from, to do
                    api.nvim_buf_set_extmark(buf, ns, math.min(math.max(row - 1, 0), last), 0,
                        { sign_text = sign.text, sign_hl_group = sign.hl })
                end
                ::continue::
            end
        end)
    end)
end

api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
    group = api.nvim_create_augroup("gitdiff", { clear = true }),
    callback = update_sign
})
