local dap = require('dap')
local nnoremap = require('utils').nnoremap
local widgets = require('dap.ui.widgets')

local dap_breakpoint = {
	breakpoint = {
		text = "",
		texthl = "LspDiagnosticsSignError",
		linehl = "",
		numhl = "",
	},
	rejected = {
		text = "◌",
		texthl = "LspDiagnosticsSignHint",
		linehl = "",
		numhl = "",
	},
	stopped = {
		text = "",
		texthl = "LspDiagnosticsSignInformation",
		linehl = "DiagnosticUnderlineInfo",
		numhl = "LspDiagnosticsSignInformation",
	},
}

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.breakpoint)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

local set_close_keybindings = function(close_handler, bufnr)
	local opts = {}
	if bufnr ~= nil then
		opts.buffer = bufnr
	end
	vim.keymap.set('', 'q', close_handler, opts)
	vim.keymap.set('', '<esc>', close_handler, opts)
end

local terminal_bufnr = nil
dap.defaults.fallback.terminal_win_cmd = function()
	terminal_bufnr = vim.api.nvim_create_buf(false, true)
	return terminal_bufnr
end

local terminal_win = nil
local close_terminal_win = function()
	if terminal_win ~= nil then
		pcall(function()
			vim.api.nvim_win_close(terminal_win, true)
		end)
		terminal_win = nil
	end
end

nnoremap('<LocalLeader>dT', function()
	if terminal_bufnr == nil then
		return
	end

	if terminal_win == nil then
		current_window_height = vim.api.nvim_win_get_height(0)
		current_window_width = vim.api.nvim_win_get_width(0)
		terminal_win = vim.api.nvim_open_win(terminal_bufnr, 0, {
			relative = 'win',
			row = math.floor(current_window_height * 0.05),
			col = math.floor(current_window_width * 0.05),
			height = math.floor(current_window_height * 0.9),
			width = math.floor(current_window_width * 0.9),
			style = 'minimal',
			border = 'single',
		})

		set_close_keybindings(close_terminal_win, terminal_bufnr)
	else
		close_terminal_win()
	end
end)

nnoremap('<LocalLeader>bb', [[<cmd>lua require('dap').toggle_breakpoint()<cr>]])
nnoremap('<LocalLeader>bc', [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]])
nnoremap('<LocalLeader>bl', [[<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>]])
nnoremap('<LocalLeader>bx', [[<cmd>lua require('dap').clear_breakpoints()<cr>]])
nnoremap('<LocalLeader>ba', '<cmd>Telescope dap list_breakpoints<cr>')

nnoremap('<LocalLeader>dc', [[<cmd>lua require('dap').continue()<cr>]])
nnoremap('<LocalLeader>dC', [[<cmd>lua require('dap').run_to_cursor()<cr>]])
nnoremap('<LocalLeader>do', [[<cmd>lua require('dap').step_over()<cr>]])
nnoremap('<LocalLeader>dj', [[<cmd>lua require('dap').step_into()<cr>]])
nnoremap('<LocalLeader>dk', [[<cmd>lua require('dap').step_out()<cr>]])
nnoremap('<LocalLeader>dq', [[<cmd>lua require('dap').terminate()<cr>]])
nnoremap('<LocalLeader>dr', [[<cmd>lua require('dap').restart()<cr>]])
nnoremap('<LocalLeader>dR', [[<cmd>lua require('dap').restart_frame()<cr>]])
nnoremap('<LocalLeader>dp', [[<cmd>lua require('dap').repl.toggle()<cr>]])

local get_widget_callback = (function()
	local view = nil
	local close_view = function()
		if view ~= nil then
			view.close()
			view = nil
		end
	end
	return function(element)
		return function()
			view = widgets.centered_float(element)
			vim.keymap.set('', 'q', close_view)
			vim.keymap.set('', '<esc>', close_view)
		end
	end
end)()

nnoremap('<LocalLeader>df', get_widget_callback(widgets.frames))
nnoremap('<LocalLeader>ds', get_widget_callback(widgets.scopes))
nnoremap('<LocalLeader>dS', get_widget_callback(widgets.sessions))
nnoremap('<LocalLeader>dt', get_widget_callback(widgets.threads))
