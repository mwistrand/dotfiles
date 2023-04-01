local dap = require('dap')
local widgets = require('dap.ui.widgets')

local M = {}

local function set_close_keybindings(close_handler, bufnr)
	local opts = {}
	if bufnr ~= nil then
		opts.buffer = bufnr
	end
	vim.keymap.set('', 'q', close_handler, opts)
	vim.keymap.set('', '<esc>', close_handler, opts)
end

-- toggle dap console
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

function M.toggle_dap_terminal()
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
end
-- end toggle dap console

M.get_widget_callback = (function()
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

local footer_state = {
	is_open = false,
	frames = nil,
	scopes = nil,
}

local function new_widget_view(widget, height, width, index)
	local position_cmd = index == 0 and 'split' or 'vsplit'
	return widgets.builder(widget)
		.new_win(function()
			vim.cmd('belowright ' .. position_cmd)
			local win = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_option(win, 'number', false)
			vim.api.nvim_win_set_option(win, 'relativenumber', false)
			vim.api.nvim_win_set_option(win, 'statusline', ' ')

			if index == 0 then
				vim.api.nvim_win_set_height(win, height)
			else
				vim.api.nvim_win_set_width(win, width)
			end
			return win
		end)
		.new_buf(widgets.with_refresh(widget.new_buf, widget.refresh_listener or 'event_stopped'))
		.build()
end

function M.open_footer()
	local current_window = vim.api.nvim_get_current_win()
	local current_window_height = vim.api.nvim_win_get_height(0)
	local current_window_width = vim.api.nvim_win_get_width(0)
	local footer_height = math.floor(current_window_height * 0.3)
	local frames_width = math.floor(current_window_width * 0.3)
	local scopes_width = math.floor(current_window_width * 0.7)

	if footer_state.frames == nil then
		footer_state.frames = new_widget_view(widgets.frames, footer_height, frames_width, 0)
	end

	if footer_state.scopes == nil then
		footer_state.scopes = new_widget_view(widgets.scopes, footer_height, scopes_width, 1)
	end

	footer_state.frames.open()
	footer_state.scopes.open()
	footer_state.is_open = true
	vim.api.nvim_set_current_win(current_window)
end

function M.close_footer()
	local frames = footer_state.frames
	local scopes = footer_state.scopes

	if frames ~= nil then
		frames.close()
	end
	if scopes ~= nil then
		scopes.close()
	end

	footer_state.is_open = false
end

function M.toggle_footer()
	if footer_state.is_open then
		M.close_footer()
	else
		M.open_footer()
	end
end

return M
