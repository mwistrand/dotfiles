local api = vim.api
local map = require('utils').map

map('<leader>f', ':Files<CR>')
map('<leader>g', ':GitFiles<CR>')
map('<leader>l', ':Lines<CR>')
map('<leader>r', ':Buffers<CR>')
map('<leader>s', ':BLines<CR>')

api.nvim_exec(
  [[
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --follow --color=always '.<q-args>.' || true', 1, <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
  command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
  command! -bang -nargs=? -complete=dir GitFiles call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)
  ]],
  false
)
