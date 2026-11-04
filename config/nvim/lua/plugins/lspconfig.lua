local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local null_ls = require('null-ls')
local utils = require('utils')

local nnoremap = utils.nnoremap
local vnoremap = utils.vnoremap

local function current_buf_root(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname == '' then
        return vim.fn.getcwd()
    end

    return vim.fs.dirname(bufname)
end

local function root_dir_or_file(markers)
    return function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, markers)
        if not root then
            root = current_buf_root(bufnr)
        end

        if root then
            on_dir(root)
        end
    end
end

local function root_dir_only(markers)
    return function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, markers)
        if root then
            on_dir(root)
        end
    end
end

local function get_go_mod_cache()
    local mod_cache = vim.g.dotfiles_go_mod_cache
    if mod_cache == nil then
        mod_cache = vim.fn.systemlist({ 'go', 'env', 'GOMODCACHE' })[1] or ''
        vim.g.dotfiles_go_mod_cache = mod_cache
    end

    return mod_cache
end

local function get_probe_dir(root_dir)
    local node_modules = vim.fs.find('node_modules', { path = root_dir, upward = true })[1]
    if not node_modules then
        return ''
    end

    return vim.fs.dirname(node_modules) .. '/node_modules'
end

local function get_angular_core_version(root_dir)
    local node_modules = vim.fs.find('node_modules', { path = root_dir, upward = true })[1]
    if not node_modules then
        return ''
    end

    local project_root = vim.fs.dirname(node_modules)
    local package_json = project_root .. '/package.json'
    if vim.uv.fs_stat(package_json) == nil then
        return ''
    end

    local handle = io.open(package_json, 'r')
    if not handle then
        return ''
    end

    local ok, contents = pcall(handle.read, handle, '*a')
    handle:close()
    if not ok then
        return ''
    end

    local json_ok, json = pcall(vim.json.decode, contents)
    if not json_ok or not json.dependencies then
        return ''
    end

    local angular_core_version = json.dependencies['@angular/core']
    angular_core_version = angular_core_version and angular_core_version:match('%d+%.%d+%.%d+')

    return angular_core_version or ''
end

local function angular_cmd(dispatchers, config)
    local root_dir = config.root_dir or vim.fn.getcwd()
    local probe_dir = get_probe_dir(root_dir)
    local angular_core_version = get_angular_core_version(root_dir)

    return vim.lsp.rpc.start({
        vim.fn.exepath('ngserver'),
        '--stdio',
        '--tsProbeLocations',
        probe_dir,
        '--ngProbeLocations',
        probe_dir,
        '--angularCoreVersion',
        angular_core_version,
    }, dispatchers, {
        cwd = root_dir,
        detached = true,
    })
end

local function eslint_cmd(dispatchers, config)
    local root_dir = config.root_dir or vim.fn.getcwd()
    local cmd = { 'vscode-eslint-language-server', '--stdio' }

    if vim.uv.fs_stat(root_dir .. '/.pnp.cjs') or vim.uv.fs_stat(root_dir .. '/.pnp.js') then
        cmd = vim.list_extend({ 'yarn', 'exec' }, cmd)
    end

    return vim.lsp.rpc.start(cmd, dispatchers, {
        cwd = root_dir,
        detached = true,
    })
end

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
    ensure_installed = { 'angularls', 'eslint', 'html', 'basedpyright', 'gopls', 'jdtls', 'ltex_plus', 'lua_ls', 'svelte', 'tailwindcss', 'ts_ls' },
    automatic_installation = true,
    automatic_enable = true,
    ui = { check_outdated_servers_on_open = true },
})

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.vale,
        null_ls.builtins.formatting.prettier.with({
            filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte', 'json', 'yaml', 'markdown' },
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
    nnoremap('<LocalLeader>lc', ':cclose<cr>', opts)

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
            -- Only format JS/TS files with null-ls (Prettier) or eslint
            local ft = vim.bo[bufnr].filetype
            if vim.tbl_contains({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' }, ft) then
                vim.lsp.buf.format({
                    async = false,
                    filter = function(c)
                        return c.name == 'null-ls' or c.name == 'eslint'
                    end,
                })
            else
                vim.lsp.buf.format({ async = false })
            end
        end,
    })
end

local capabilities = vim.tbl_deep_extend(
    'force',
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities(),
    require('lsp-file-operations').default_capabilities()
)

local function create_config(factory)
    factory = factory or function(config)
        return config
    end

    return factory({
        capabilities = capabilities,
        on_attach = on_attach,
    })
end

vim.lsp.config('basedpyright', create_config(function(config)
    config.cmd = { 'basedpyright-langserver', '--stdio' }
    config.filetypes = { 'python' }
    config.root_dir = root_dir_or_file({
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git',
    })
    config.settings = {
        basedpyright = {
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

vim.lsp.config('svelte', create_config(function(config)
    config.cmd = { 'svelteserver', '--stdio' }
    config.filetypes = { 'svelte' }
    config.root_dir = root_dir_only({ 'svelte.config.js', 'svelte.config.cjs', 'package.json', '.git' })
    config.settings = {
        svelte = {
            plugin = {
                svelte = {
                    format = {
                        enable = true, -- Enable Svelte formatter
                    },
                },
                typescript = {
                    diagnostics = {
                        enable = true, -- Enable TypeScript diagnostics in Svelte files
                    },
                },
            },
        },
    }
    return config
end))

vim.lsp.config('gopls', create_config(function(config)
    config.cmd = { 'gopls' }
    config.filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' }
    config.root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local mod_cache = get_go_mod_cache()

        if mod_cache ~= '' and fname:sub(1, #mod_cache) == mod_cache then
            local clients = vim.lsp.get_clients({ name = 'gopls' })
            if #clients > 0 and clients[#clients].config and clients[#clients].config.root_dir then
                on_dir(clients[#clients].config.root_dir)
                return
            end
        end

        local root = vim.fs.root(bufnr, { 'go.work', 'go.mod', '.git' })
        if not root then
            root = current_buf_root(bufnr)
        end

        on_dir(root)
    end
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
vim.lsp.config('ts_ls', create_config(function(config)
    config.cmd = { 'typescript-language-server', '--stdio' }
    config.filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
    config.root_dir = root_dir_or_file({ 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' })
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
vim.lsp.config('eslint', create_config(function(config)
    config.cmd = eslint_cmd
    config.filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' }
    config.root_dir = root_dir_only({
        {
            '.eslintrc',
            '.eslintrc.js',
            '.eslintrc.cjs',
            '.eslintrc.yaml',
            '.eslintrc.yml',
            '.eslintrc.json',
            'eslint.config.js',
            'eslint.config.mjs',
            'eslint.config.ts',
        },
        'package.json',
        '.git',
    })
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
    config.before_init = function(_, lsp_config)
        local root_dir = lsp_config.root_dir or vim.fn.getcwd()
        lsp_config.settings = lsp_config.settings or {}
        lsp_config.settings.workspaceFolder = {
            uri = vim.uri_from_fname(root_dir),
            name = vim.fn.fnamemodify(root_dir, ':t'),
        }

        if
            vim.uv.fs_stat(root_dir .. '/eslint.config.js') ~= nil
            or vim.uv.fs_stat(root_dir .. '/eslint.config.mjs') ~= nil
            or vim.uv.fs_stat(root_dir .. '/eslint.config.cjs') ~= nil
            or vim.uv.fs_stat(root_dir .. '/eslint.config.ts') ~= nil
            or vim.uv.fs_stat(root_dir .. '/eslint.config.mts') ~= nil
            or vim.uv.fs_stat(root_dir .. '/eslint.config.cts') ~= nil
        then
            lsp_config.settings.experimental = lsp_config.settings.experimental or {}
            lsp_config.settings.experimental.useFlatConfig = true
        end
    end
    return config
end))

-- Angular LSP - provides Angular-specific features
-- Works alongside ts_ls for full TypeScript + Angular support
vim.lsp.config('angularls', create_config(function(config)
    config.cmd = angular_cmd
    config.filetypes = { 'typescript', 'html', 'typescriptreact', 'htmlangular' }
    config.root_dir = root_dir_only({ 'angular.json', 'project.json' })
    return config
end))

vim.lsp.enable({ 'basedpyright', 'svelte', 'gopls', 'ts_ls', 'eslint', 'angularls' })

-- allow the default config to be used by ftplugin files
local M = {}
M.create_config = create_config
M.on_attach = on_attach
return M
