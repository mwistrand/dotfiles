local copilot = require('copilot')
local chat = require('CopilotChat')
local nnoremap = require('utils').nnoremap

copilot.setup({
	cmd = 'Copilot',
	cond = not vim.g.vscode,
	build = ':Copilot auth',
	event = 'InsertEnter',
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = '<Tab>',
				close = '<Esc>',
				next = '<C-J>',
				prev = '<C-K>',
				select = '<CR>',
				dismiss = '<C-X>',
			},
		},
		panel = {
			enabled = false,
		},
	},
	{
		'zbirenbaum/copilot-cmp',
		cond = not vim.g.vscode,
		dependencies = {
			'hrsh7th/nvim-cmp',
		},
		config = true,
	},
})

chat.setup({
	window = {
		position = 'right',
		width = 0.4,
	},
	prompts = {
		Explain = {
			mapping = '<leader>ae',
			description = 'AI Explain',
		},
		Review = {
			mapping = '<leader>ar',
			description = 'AI Review',
		},
		Tests = {
			mapping = '<leader>at',
			description = 'AI Tests',
		},
		Fix = {
			mapping = '<leader>af',
			description = 'AI Fix',
		},
		Optimize = {
			mapping = '<leader>ao',
			description = 'AI Optimize',
		},
		Docs = {
			mapping = '<leader>ad',
			description = 'AI Documentation',
		},
	},
})

nnoremap('<leader>aa', chat.toggle, { desc = 'AI toggle' })
nnoremap('<leader>ax', chat.reset, { desc = 'AI reset' })
nnoremap('<leader>as', chat.stop, { desc = 'AI stop' })
