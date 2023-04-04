local nnoremap = require('utils').nnoremap
local ui = require('plugins.dap-ui')
local widgets = require('dap.ui.widgets')

ui.setup({})

local dap_breakpoint = {
	breakpoint = {
		text = '🔴',
		texthl = 'LspDiagnosticsSignError',
		linehl = '',
		numhl = '',
	},
	conditional = {
		text = '🟡',
		texthl = 'LspDiagnosticsSignError',
		linehl = '',
		numhl = '',
	},
	log = {
		text = '🟢',
		texthl = 'LspDiagnosticsSignError',
		linehl = '',
		numhl = '',
	},
	rejected = {
		text = '❌',
		texthl = 'LspDiagnosticsSignHint',
		linehl = '',
		numhl = '',
	},
	stopped = {
		text = '⭕',
		texthl = 'LspDiagnosticsSignInformation',
		linehl = 'DiagnosticUnderlineInfo',
		numhl = 'LspDiagnosticsSignInformation',
	},
}

vim.fn.sign_define('DapBreakpoint', dap_breakpoint.breakpoint)
vim.fn.sign_define('DapBreakpointCondition', dap_breakpoint.conditional)
vim.fn.sign_define('DapLogPoint', dap_breakpoint.log)
vim.fn.sign_define('DapStopped', dap_breakpoint.stopped)
vim.fn.sign_define('DapBreakpointRejected', dap_breakpoint.rejected)

nnoremap('<LocalLeader>bb', [[<cmd>lua require('dap').toggle_breakpoint()<cr>]])
nnoremap('<LocalLeader>bc', [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]])
nnoremap('<LocalLeader>bl', [[<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>]])
nnoremap('<LocalLeader>bx', [[<cmd>lua require('dap').clear_breakpoints()<cr>]])
nnoremap('<LocalLeader>ba', '<cmd>Telescope dap list_breakpoints<cr>')

nnoremap('<LocalLeader>n', [[<cmd>lua require('dap').continue()<cr>]])
nnoremap('<LocalLeader>C', [[<cmd>lua require('dap').run_to_cursor()<cr>]])
nnoremap('<LocalLeader>o', [[<cmd>lua require('dap').step_over()<cr>]])
nnoremap('<LocalLeader>j', [[<cmd>lua require('dap').step_into()<cr>]])
nnoremap('<LocalLeader>k', [[<cmd>lua require('dap').step_out()<cr>]])
nnoremap('<LocalLeader>R', [[<cmd>lua require('dap').restart_frame()<cr>]])

nnoremap('<LocalLeader>dc', ui.toggle_dap_terminal)
nnoremap('<LocalLeader>dq', [[<cmd>lua require('dap').terminate()<cr>]])
nnoremap('<LocalLeader>dr', [[<cmd>lua require('dap').restart()<cr>]])
nnoremap('<LocalLeader>dp', [[<cmd>lua require('dap').repl.toggle()<cr>]])
nnoremap('<LocalLeader>D', ui.toggle_footer)
nnoremap('<LocalLeader>df', ui.get_widget_callback(widgets.frames))
nnoremap('<LocalLeader>ds', ui.get_widget_callback(widgets.scopes))
nnoremap('<LocalLeader>dS', ui.get_widget_callback(widgets.sessions))
nnoremap('<LocalLeader>dt', ui.get_widget_callback(widgets.threads))
-- TODO <LocalLeader>dd => toggle debugger vs console buffer once anchored
