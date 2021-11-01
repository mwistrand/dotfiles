require('lualine').setup({
  options = {
    theme = 'dracula',
	component_separators = { left = '•', right = '•' }
  },
  sections = {
	lualine_a = {'mode'},
	lualine_b = {'FugitiveHead', {'diagnostics', sources={'nvim_lsp', 'coc'}}},
	lualine_c = {'filename'},
	lualine_x = {
	  'encoding',
	  {'filetype', icons_enabled = false}
	},
	lualine_y = {'progress'},
	lualine_z = {'location'}
  },
  extensions = {'fugitive', 'nvim-tree'}
})
