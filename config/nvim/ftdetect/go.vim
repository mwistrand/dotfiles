autocmd BufWritePre *.go lua vim.lsp.buf.format()
autocmd BufWritePre *.go lua vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
