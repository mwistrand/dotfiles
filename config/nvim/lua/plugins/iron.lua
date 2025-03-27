local utils = require('utils')

require('iron.core').setup({
	config = {
		scratch_repl = true,
		repl_definition = {
			python = {
				command = { 'ipython', '--no-autoindent' },
				format = require('iron.fts.common').bracketed_paste_python,
			},
		},
		repl_open_cmd = require('iron.view').right(80),
		repl_filetype = function(bufnr, ft)
			return ft
		end,
	},
	highlight = {
		italic = true,
	},
	keymaps = {
		restart_repl = '<LocalLeader>c',
		toggle_repl = '<LocalLeader>dd',
		clear = '<LocalLeader>dc',
		interrupt = '<LocalLeader>ds',
		exit = '<LocalLeader>dq',
		visual_send = '<LocalLeader>ee',
		send_line = '<LocalLeader>el',
		send_code_block = '<LocalLeader>ee',
		send_file = '<LocalLeader>ef',
		send_until_cursor = '<LocalLeader>ec',
		cr = '<LocalLeader>e<cr>',
	}
})
utils.nmap('<LocalLeader>df', '<cmd>IronFocus<cr>')
