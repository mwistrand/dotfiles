local lspconfig = require('lspconfig')
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local null_ls = require('null-ls')
local utils = require('utils')
local vscode = require('dap.ext.vscode')

local nnoremap = utils.nnoremap
local vnoremap = utils.vnoremap

mason.setup({
    ui = {
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗'
        }
    }
})

mason_lspconfig.setup({
    ensure_installed = { 'angularls', 'eslint', 'html', 'basedpyright', 'gopls', 'jdtls', 'lua_ls', 'svelte', 'tailwindcss', 'ts_ls' },
    automatic_installation = true,
    automatic_enable = true,
    ui = { check_outdated_servers_on_open = true },
})

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.vale,
        null_ls.builtins.formatting.prettier.with({
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "json", "yaml", "markdown" },
        }),
    },
})

local on_attach = function(client, bufnr)
    local opts = { buffer = bufnr }
    nnoremap('gD', vim.lsp.buf.declaration, opts)
    nnoremap('gd', vim.lsp.buf.definition, opts)
    nnoremap('gt', vim.lsp.buf.type_definition, opts)
    nnoremap('gi', vim.lsp.buf.implementation, opts)
    nnoremap('<C-]>', vim.lsp.buf.implementation, opts)
    nnoremap('gr', vim.lsp.buf.references, opts)

    nnoremap('K', vim.lsp.buf.hover, opts)
    nnoremap('<C-k>', vim.lsp.buf.signature_help, opts)

    nnoremap('ga', vim.lsp.buf.code_action, opts)
    vnoremap('ga', vim.lsp.buf.code_action, opts)

    nnoremap('<LocalLeader>ll', ':LspRestart<cr>', opts)

    nnoremap('<LocalLeader>rn', vim.lsp.buf.rename, opts)
    nnoremap('<LocalLeader>rf', function()
        vim.lsp.buf.format({ async = true })
    end, opts)

    nnoremap('<LocalLeader>wa', vim.lsp.buf.add_workspace_folder, opts)
    nnoremap('<LocalLeader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    nnoremap('<LocalLeader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)

    -- When angularls is attached, disable rename for ts_ls to avoid conflicts
    -- angularls provides better rename support across component/template boundaries
    local angularls_clients = vim.lsp.get_clients({ bufnr = bufnr, name = 'angularls' })
    if #angularls_clients > 0 and client.name == 'ts_ls' then
        client.server_capabilities.renameProvider = false
    end

    -- Disable formatting for ts_ls - let eslint or prettier handle it
    if client.name == 'ts_ls' then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end

    -- Format on save
    vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
            -- Only format JS/TS files with null-ls (Prettier)
            local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
            if vim.tbl_contains({ "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" }, ft) then
                vim.lsp.buf.format({
                    async = false,
                    filter = function(client)
                        return client.name == "null-ls"
                    end,
                })
            else
                vim.lsp.buf.format({ async = false })
            end
        end,
    })
end

local create_config = function(factory)
    factory = factory or function(config)
        return config
    end

    local capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities(),
        require('lsp-file-operations').default_capabilities()
    )

    return factory({ capabilities = capabilities, on_attach = on_attach })
end

lspconfig.basedpyright.setup(create_config(function(config)
    config.settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
                typeCheckingMode = 'off'
            },
        },
    }
    return config
end))

lspconfig.gopls.setup(create_config(function(config)
    config.cmd = {'gopls'}
    config.filetypes = {'go', 'gomod', 'gowork', 'gotmpl'}
    config.root_dir = lspconfig.util.root_pattern('go.mod', '.git')
    config.settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    }
    return config
end))

-- TypeScript/JavaScript LSP
-- Supports multi-root workspaces with multiple tsconfig.json files
lspconfig.ts_ls.setup(create_config(function(config)
    config.filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
    config.root_dir = lspconfig.util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git')
    config.settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = 'all',
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
    }
    return config
end))

-- ESLint LSP - provides linting and formatting
lspconfig.eslint.setup(create_config(function(config)
    config.filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' }
    config.root_dir = lspconfig.util.root_pattern(
        '.eslintrc',
        '.eslintrc.js',
        '.eslintrc.cjs',
        '.eslintrc.yaml',
        '.eslintrc.yml',
        '.eslintrc.json',
        'eslint.config.js',
        'package.json'
    )
    config.settings = {
        codeAction = {
            disableRuleComment = {
                enable = true,
                location = 'separateLine'
            },
            showDocumentation = {
                enable = true
            }
        },
        codeActionOnSave = {
            enable = false,  -- We handle this separately
            mode = 'all'
        },
        format = true,
        nodePath = '',
        onIgnoredFiles = 'off',
        packageManager = 'npm',
        quiet = false,
        rulesCustomizations = {},
        run = 'onType',
        useESLintClass = false,
        validate = 'on',
        workingDirectory = {
            mode = 'location'
        }
    }
    return config
end))

-- Angular LSP - provides Angular-specific features
-- Works alongside ts_ls for full TypeScript + Angular support
lspconfig.angularls.setup(create_config(function(config)
    config.root_dir = lspconfig.util.root_pattern('angular.json', 'project.json')
    return config
end))

-- load any debugger configuration available in the current project
vscode.load_launchjs()

-- allow the default config to be used by ftplugin files
local M = {}
M.create_config = create_config
M.on_attach = on_attach
return M
