local rt = require('rust-tools')
local dap = require('rust-tools.dap')
local utils = require('utils')

local nnoremap = utils.nnoremap

rt.setup({
	server = {
		on_attach = function(_, bufnr)
			local opts = { buffer = bufnr }
			nnoremap('<LocalLeader>c', function()
				dap.start({})
			end, opts)
		end,
	}
})

