local api = vim.api

-- Remove trailing whitespace for all files on save
api.nvim_exec(
	[[
	augroup FormatAugroup
		autocmd!
		autocmd BufWritePre * :%s/\s\+$//e
	augroup END
	]],
	true
)
