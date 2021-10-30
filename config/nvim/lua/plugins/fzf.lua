local api = vim.api
local utils = require('utils')

utils.map('<leader>f', ':Files<CR>')
utils.map('<leader>g', ':GitFiles<CR>')
utils.map('<leader>l', ':Lines<CR>')
utils.map('<leader>r', ':Buffers<CR>')
utils.map('<leader>s', ':BLines<CR>')

api.nvim_exec(
  [[
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --follow --color=always '.<q-args>.' || true', 1, <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
  command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
  command! -bang -nargs=? -complete=dir GitFiles call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)
  ]],
  false
)
