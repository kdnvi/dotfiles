vim.lsp.config("pyright", {
    cmd = {"pyright-langserver", "--stdio"},
    filetypes = { "python" },
    -- root_markers = { "pyrightconfig.json", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
    root_dir = vim.uv.cwd(),
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true
            }
        }
    }
})
