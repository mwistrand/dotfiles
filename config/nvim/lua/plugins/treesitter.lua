require('nvim-treesitter.configs').setup({
	ensure_installed = {
		'bash',
		'comment',
		'css',
		'diff',
		'dockerfile',
		'git_rebase',
		'gitcommit',
		'gitignore',
		'go',
		'help',
		'html',
		'java',
		'javascript',
		'jsdoc',
		'json',
		'jsonc',
		'kotlin',
		'latex',
		'lua',
		'markdown',
		'markdown_inline',
		'python',
		'ruby',
		'rust',
		'scala',
		'toml',
		'typescript',
		'vim',
		'yaml',
	},
	highlight = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = 'gnn',
			node_incremental = 'grn',
			scope_incremental = 'grc',
			node_decremental = 'grm',
		},
	},
})
