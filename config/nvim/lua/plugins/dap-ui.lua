local dap = require('dap')
local widgets = require('dap.ui.widgets')

local M = {}

local footer_config_defaults = {
	height = 0.3,
	groups = {
		{
			name = 'frames_and_scopes',
			widgets = {
				{ name = 'frames', width = 0.3 },
				{ name = 'scopes', width = 0.7 },
			}
		},
	},
}

local footer_state = {
	config = footer_config_defaults,

	is_open = false,
	active_group = nil,

	console = nil,
	frames = nil,
	scopes = nil,
}

function M.setup(config)
	-- TODO validate config
	footer_state.config = {
		height = config.height or footer_config_defaults.height,
		groups = config.groups or footer_config_defaults.groups,
	}
end

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

local function new_widget_view(widget, height, width, index)
	local position_cmd = index == 1 and 'split' or 'vsplit'
	return widgets.builder(widget)
		.new_win(function()
			vim.cmd('belowright ' .. position_cmd)
			local win = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_option(win, 'number', false)
			vim.api.nvim_win_set_option(win, 'relativenumber', false)
			vim.api.nvim_win_set_option(win, 'statusline', ' ')

			if index == 1 then
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
	local config = footer_state.config
	local active_group = config.active_group or config.groups[1]

	local current_window = vim.api.nvim_get_current_win()
	local current_window_height = vim.api.nvim_win_get_height(0)
	local current_window_width = vim.api.nvim_win_get_width(0)
	local footer_height = math.floor(current_window_height * config.height)

	for i, widget_config in ipairs(active_group.widgets) do
		local name = widget_config.name
		if footer_state[name] == nil then
			local width = math.floor(current_window_width * widget_config.width)
			footer_state[name] = new_widget_view(widgets[name], footer_height, width, i)
		end
		footer_state[name].open()
	end

	footer_state.active_group = active_group
	footer_state.is_open = true
	vim.api.nvim_set_current_win(current_window)
end

function M.close_footer()
	local active_group = footer_state.active_group

	for i, widget_config in ipairs(active_group.widgets) do
		local name = widget_config.name
		if footer_state[name] ~= nil then
			footer_state[name].close()
		end
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

function M.show_group(group)
end

function M.get_show_group_command(group)
	return function()
		M.show_group(group)
	end
end

return M
