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
    ensure_installed = { 'angularls', 'html', 'basedpyright', 'gopls', 'jdtls', 'lua_ls', 'svelte', 'tailwindcss' },
    automatic_installation = true,
    automatic_enable = true,
    ui = { check_outdated_servers_on_open = true },
})

null_ls.setup({
    sources = { null_ls.builtins.diagnostics.vale, },
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

    nnoremap('<LocalLeader>rn', vim.lsp.buf.rename, opts)
    nnoremap('<LocalLeader>rf', function()
        vim.lsp.buf.format({ async = true })
    end, opts)

    nnoremap('<LocalLeader>wa', vim.lsp.buf.add_workspace_folder, opts)
    nnoremap('<LocalLeader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    nnoremap('<LocalLeader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)

    -- use angularls for renames
    local clients = vim.lsp.get_clients({ bufnr = bufnr, name = 'angularls' })
    if #clients > 0 then
      client.server_capabilities.renameProvider = false
    end

    -- Format on save if supported
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end
end

local create_config = function(factory)
    factory = factory or function(config)
        return config
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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

-- load any debugger configuration available in the current project
vscode.load_launchjs()

-- allow the default config to be used by ftplugin files
local M = {}
M.create_config = create_config
M.on_attach = on_attach
return M
