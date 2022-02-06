local actions = require('telescope.actions')
local utils = require('utils')

utils.nnoremap('\\', '<cmd>Telescope live_grep<cr>')

require('telescope').setup({
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
