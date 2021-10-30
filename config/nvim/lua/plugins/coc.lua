local g = vim.g
local utils = require('utils')

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
utils.nmap('gr', '<Plug>(coc-references)')

local function check_back_space()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')) and true
end

-- h/t https://github.com/smauel/dotfiles/blob/master/nvim/lua/config/coc.lua
local function CocSmartTab()
  if fn.pumvisible() == 1 then
    return termcodes('<C-n>')
  elseif fn['coc#expandableOrJumpable']() == 1 then
    return termcodes('<C-r>') .. [[=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])]] .. termcodes('<CR>')
  else
    local status, result = pcall(check_back_space)
    if status and result then
      return termcodes('<Tab>')
    else
      return fn['coc#refresh()']()
    end
  end
end

-- When popup menu is visible, tab goes to next entry.
-- Else, if the cursor is in an active snippet, tab between fields.
-- Else, if the character before the cursor isn't whitespace, put a Tab.
-- Else, refresh the completion list
--inoremap('<TAB>', 'v:lua.CocSmartTab()', {silent = true, expr = true})
utils.inoremap('<Tab>', 'v:lua.CocSmartTab()', { expr = true })

-- Shift-Tab for cycling backwards through matches in a completion popup
--inoremap('<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<C-h>"', {silent = true, expr = true})
utils.inoremap('<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<C-h>"', { expr = true })

-- Enter to confirm completion
--inoremap('<CR>', 'pumvisible() ? "\\<C-y>" : "\\<CR>"', {silent = true, expr = true})
utils.inoremap('<CR>', 'pumvisible() ? "\\<C-y>" : "\\<CR>"', { expr = true })
