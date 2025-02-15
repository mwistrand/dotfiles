local actions = require('telescope.actions')
local nnoremap = require('utils').nnoremap
local inoremap = require('utils').inoremap
local telescope = require('telescope')

nnoremap('\\', '<cmd>Telescope live_grep<cr>')

telescope.setup({
  defaults = {
	mappings = {
	  i = {
		['<ESC>'] = actions.close,
		['<C-j>'] = actions.move_selection_next,
		['<C-k>'] = actions.move_selection_previous,
		['<C-e>'] = actions.preview_scrolling_down,
		['<C-y>'] = actions.preview_scrolling_up
	  }
	}
  }
})

telescope.load_extension('dap')
