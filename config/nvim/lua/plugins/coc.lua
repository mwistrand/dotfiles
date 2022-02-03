local fn = vim.fn
local g = vim.g
local utils = require('utils')

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- coc settings
g.coc_global_extensions = {
  'coc-css',
  'coc-emmet',
  'coc-emoji',
  'coc-eslint',
  'coc-java',
  'coc-jest',
  'coc-json',
  'coc-pairs',
  'coc-prettier',
  'coc-svg',
  'coc-tslint-plugin',
  'coc-tsserver',
  'coc-yaml',
}

-- use coc.nvim for goto shortcuts
utils.nmap('gf', '<Plug>(coc-definition)')
utils.nmap('gi', '<Plug>(coc-implementation)')
utils.nmap('<C-]>', '<Plug>(coc-implementation)')
utils.nmap('gr', '<Plug>(coc-references)')

-- When popup menu is visible, tab goes to next entry; otherwise, ignore
utils.inoremap('<Tab>', "pumvisible() ? '<c-n>' : '<Tab>'", { expr = true })

-- Shift-Tab for cycling backwards through matches in a completion popup
utils.inoremap('<S-Tab>', 'pumvisible() ? "<C-p>" : "<C-h>"', { expr = true })

-- Enter to confirm completion
utils.inoremap('<CR>', 'pumvisible() ? "<C-y>" : "<CR>"', { expr = true })
