local function changed_lines(buf, file)
    local out = vim.system({'git', 'diff', '--no-ext-diff', '-U0', '--', file}, {stdout=true}):wait()
    if out.code ~= 0 then return {} end

    local lines = {}
    local line_count = vim.api.nvim_buf_line_count(buf)
    for line in out.stdout:gmatch('[^\n]+') do
        local osta, ocnt, nsta, ncnt = line:match('^@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@')
        if osta then
            ocnt = tonumber(ocnt) or 1
            nsta = tonumber(nsta)
            ncnt = tonumber(ncnt) or 1

            if ocnt == 0 and ncnt > 0 then
                for lnum = nsta, nsta+ncnt-1 do lines[#lines+1] = {1, lnum} end
            elseif ncnt == 0 then -- 1 is add sign
                lines[#lines+1] = {nsta==0 and 3 or 4, nsta==0 and 1 or math.min(nsta, line_count)}
            elseif ocnt > 0 and ncnt > 0 then -- 3/4 is del above/below sign
                for lnum = nsta, nsta+ncnt-1 do lines[#lines+1] = {2, lnum} end
            end -- 2 is modify sign
        end -- checkout sign definition below
    end
    return lines
end

local signs = {{text='▌', hl='Added'}, {text='▌', hl='Changed'}, {text='▔', hl='Removed'}, {text='▁', hl='Removed'}}
local ns = vim.api.nvim_create_namespace('diffsigns')
local function refresh(buf)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    local file = vim.api.nvim_buf_get_name(buf)
    if file=='' or vim.bo[buf].buftype~='' or vim.bo[buf].filetype=='netrw' then return end

    local marks = changed_lines(buf, file)
    for _, mark in ipairs(marks) do
        local def = signs[mark[1]] -- sign definition at index
        vim.api.nvim_buf_set_extmark(buf, ns, mark[2]-1, 0, {sign_text=def.text, sign_hl_group=def.hl, priority=10})
    end -- place signs
end

vim.api.nvim_create_autocmd({'BufEnter', 'BufWritePost'}, {
    group = vim.api.nvim_create_augroup('diffsigns', {clear=true}),
    callback = function(args) refresh(args.buf) end,
})
