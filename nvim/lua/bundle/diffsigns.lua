local function changed_lines(buf, file)
    local out = vim.system({'git', 'diff', '--no-ext-diff', '-U0', '--', file}, {stdout=true}):wait()
    if out.code ~= 0 then return {} end

    local lines = {}
    local line_count = vim.api.nvim_buf_line_count(buf)
    for line in out.stdout:gmatch('[^\n]+') do
        local ostart, ocount, nstart, ncount = line:match('^@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@')
        if not ostart then goto continue end

        ocount = tonumber(ocount) or 1
        nstart = tonumber(nstart)
        ncount = tonumber(ncount) or 1

        if ncount == 0 then -- del
            local sign = nstart==0 and 4 or 1
            local lnum = nstart==0 and 1 or math.min(nstart, line_count)
            lines[#lines+1] = {sign, lnum}
        elseif ncount > 0 then -- add/mod
            local sign = ocount==0 and 2 or 3
            for lnum = nstart, nstart+ncount-1 do lines[#lines+1] = {sign, lnum} end
        end -- {sign_index, line_number}
        ::continue::
    end -- e.g. @@ -12,3 +12,5 @@
    return lines
end

local ns = vim.api.nvim_create_namespace('diffsigns')
local signs = {
    {sign_text = '▁', sign_hl_group = 'Removed'},
    {sign_text = '▌', sign_hl_group = 'Added'},
    {sign_text = '▌', sign_hl_group = 'Changed'},
    {sign_text = '▔', sign_hl_group = 'Removed'},
} -- 1:delb 2:add 3:change 4:dela - just want to keep a nice shape
local function refresh(buf)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    local file = vim.api.nvim_buf_get_name(buf)
    if file=='' or vim.bo[buf].buftype~='' or vim.bo[buf].filetype=='netrw' then return end

    local marks = changed_lines(buf, file)
    for _, mark in ipairs(marks) do
        vim.api.nvim_buf_set_extmark(buf, ns, mark[2]-1, 0, signs[mark[1]])
    end -- place signs
end

vim.api.nvim_create_autocmd({'BufEnter', 'BufWritePost'}, {
    group = vim.api.nvim_create_augroup('diffsigns', {clear=true}),
    callback = function(args) refresh(args.buf) end,
})
