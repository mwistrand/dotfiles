-- local lsp_installer = require('nvim-lsp-installer')
local lspconfig = require('lspconfig')

-- lsp_installer.setup({
-- 	ensure_installed = {
-- 		'angularls',
-- 		'eslint',
-- 		'jdtls',
-- 		'tsserver',
-- 		'sumneko_lua',
-- 		'vimls'
-- 	},
-- 	automatic_installation = true,
-- 	ui = {
-- 		check_outdated_servers_on_open = true
-- 	}
-- })

lspconfig.tsserver.setup{}
