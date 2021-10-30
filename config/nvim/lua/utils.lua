local fn = fn
local utils = {}

local function copy(object)
	return object and vim.deepcopy(object) or {}
end

local map = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap
local function create_map_fn(mode, default_options)
	return function(key_sequence, command, options)
		local merged_options = vim.tbl_extend('keep', copy(default_options), copy(options))
		
		if (merged_options.buffer) then
			bufmap(mode, key_sequence, command, merged_options)
		else
			map(mode, key_sequence, command, merged_options)
		end
	end
end

local remap_options = { noremap = false, silent = true }
utils.map = create_map_fn('', remap_options)
utils.nmap = create_map_fn('n', remap_options)
utils.imap = create_map_fn('i', remap_options)
utils.vmap = create_map_fn('v', remap_options)

local noremap_options = { noremap = true, silent = true }
utils.noremap = create_map_fn('', noremap_options)
utils.nnoremap = create_map_fn('n', noremap_options)
utils.inoremap = create_map_fn('i', noremap_options)
utils.vnoremap = create_map_fn('v', noremap_options)

return utils
