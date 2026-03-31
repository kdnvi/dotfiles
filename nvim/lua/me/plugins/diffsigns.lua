local api = vim.api
local ns = api.nvim_create_namespace("diffsigns")
local signs = {
    add    = { text = "+", hl = "DiffAdd" },
    change = { text = "~", hl = "DiffChange" },
    delete = { text = "_", hl = "DiffDelete" },
}

local function mark(buf, row, sign)
    local last = api.nvim_buf_line_count(buf) - 1
    api.nvim_buf_set_extmark(buf, ns, math.min(math.max(row, 0), last), 0,
        { sign_text = sign.text, sign_hl_group = sign.hl })
end

local function delete_sign(count)
    local text = count > 99 and "_>" or count > 1 and ("_" .. count) or "_"
    return { text = text, hl = signs.delete.hl }
end

local seq = {} -- per-buffer sequence counter to discard stale async callbacks
local function update_signs(event)
    local buf = event.buf
    local name = api.nvim_buf_get_name(buf)
    if not api.nvim_buf_is_valid(buf) or #name == 0 then return end

    seq[buf] = (seq[buf] or 0) + 1
    local id = seq[buf]

    vim.system({ "git", "-C", vim.fs.dirname(name), "diff", "--no-ext-diff", "-U0", "--", name }, { text = true },
        function(result)
            vim.schedule(function()
                if id ~= seq[buf] or not api.nvim_buf_is_valid(buf) then return end
                api.nvim_buf_clear_namespace(buf, ns, 0, -1)
                if result.code ~= 0 then return end

                local placed = {}
                for hunk in result.stdout:gmatch("[^\n]+") do
                    local old_count, new_start, new_count = hunk:match("^@@ %-[%d]+,?(%d*) %+(%d+),?(%d*) @@")
                    if not new_start then goto continue end

                    old_count = tonumber(old_count) or 1
                    new_start = tonumber(new_start)
                    new_count = tonumber(new_count) or 1
                    if not new_start then goto continue end

                    if old_count == 0 then
                        for i = 0, new_count - 1 do
                            mark(buf, new_start + i - 1, signs.add)
                            placed[new_start + i] = true
                        end
                    elseif new_count == 0 then
                        mark(buf, math.max(new_start - 1, 0), delete_sign(old_count))
                    elseif old_count <= new_count then
                        for i = 0, old_count - 1 do
                            mark(buf, new_start + i - 1, signs.change)
                            placed[new_start + i] = true
                        end
                        for i = old_count, new_count - 1 do
                            mark(buf, new_start + i - 1, signs.add)
                            placed[new_start + i] = true
                        end
                    else
                        local removed = old_count - new_count
                        local prev = new_start - 1
                        if prev >= 1 and not placed[prev] then
                            mark(buf, prev - 1, delete_sign(removed))
                            mark(buf, new_start - 1, signs.change)
                        else
                            mark(buf, new_start - 1, { text = signs.change.text, hl = signs.delete.hl })
                        end
                        placed[new_start] = true
                        for i = 1, new_count - 1 do
                            mark(buf, new_start + i - 1, signs.change)
                            placed[new_start + i] = true
                        end
                    end
                    ::continue::
                end
            end)
        end)
end

api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
    group = api.nvim_create_augroup("diffsigns", { clear = true }),
    callback = update_signs
})
