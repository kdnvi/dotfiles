vim.lsp.config('zls', {
    cmd = {'zls'}, filetypes = {'zig', 'zir'}, workspace_required = false,
    root_markers = {'zls.json', 'build.zig', '.git'}
})
