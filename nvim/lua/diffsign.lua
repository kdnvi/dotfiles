local function changed_lines(buf, file)
    local out = vim.system({'git', 'diff', '--no-ext-diff', '-U0', '--', file}, {stdout=true}):wait()
    if out.code ~= 0 then return {} end

    local lines = {}
    local line_count = vim.api.nvim_buf_line_count(buf)
    for line in out.stdout:gmatch('[^\n]+') do
        local old_start, old_count, new_start, new_count = line:match('^@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@')
        if not old_start then goto continue end

        old_count = tonumber(old_count) or 1
        new_start = tonumber(new_start)
        new_count = tonumber(new_count) or 1

        if new_count == 0 then -- del
            local sign = new_start==0 and 4 or 1
            local lnum = new_start==0 and 1 or math.min(new_start, line_count)
            lines[#lines+1] = {sign, lnum}
        elseif new_count > 0 then -- add/mod
            local sign = old_count==0 and 2 or 3
            for lnum = new_start, new_start+new_count-1 do lines[#lines+1] = {sign, lnum} end
        end -- {sign_index, line_number}
        ::continue::
    end -- e.g. @@ -12,3 +12,5 @@
    return lines
end

local ns = vim.api.nvim_create_namespace('diffsign')
local signs = {
    {sign_text = '▁', sign_hl_group = 'Removed'},
    {sign_text = '▌', sign_hl_group = 'Added'},
    {sign_text = '▌', sign_hl_group = 'Changed'},
    {sign_text = '▔', sign_hl_group = 'Removed'},
} -- just want to keep a nice shape

local function refresh(buf)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    local file = vim.api.nvim_buf_get_name(buf)
    if file=='' or vim.bo[buf].buftype~='' or vim.fn.isdirectory(file)==1 then return end

    local marks = changed_lines(buf, file)
    for _, mark in ipairs(marks) do
        vim.api.nvim_buf_set_extmark(buf, ns, mark[2]-1, 0, signs[mark[1]])
    end -- place signs
end

vim.api.nvim_create_autocmd({'BufEnter', 'BufWritePost'}, {
    group = vim.api.nvim_create_augroup('diffsign', {clear=true}),
    callback = function(args) refresh(args.buf) end,
})
