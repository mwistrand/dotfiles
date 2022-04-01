-- Thanks, Nick! https://github.com/nicknisi/dotfiles/blob/master/config/nvim/lua/plugins/nvimtree.lua
local nvimtree = require('nvim-tree')
local nnoremap = require('utils').nnoremap

local view = require('nvim-tree.view')
_G.NvimTreeConfig = {}

vim.g.nvim_tree_icons = {
  default = '',
  symlink = '',
  git = {
    unstaged = '●',
    staged = '✓',
    unmerged = '',
    renamed = '➜',
    untracked = '★',
    deleted = '',
    ignored = '◌'
  },
  folder = {
    arrow_open = '',
    arrow_closed = '',
    default = '',
    open = '',
    empty = '',
    empty_open = '',
    symlink = '',
    symlink_open = ''
  },
  lsp = {
    hint = '',
    info = '',
    warning = '',
    error = ''
  }
}

-- Flatten directories that have only a single folder; useful for JVM projects
vim.g.nvim_tree_group_empty = 1

function NvimTreeConfig.find_toggle()
  if view.is_visible() then
    view.close()
  else
    vim.cmd('NvimTreeToggle')
  end
end

nnoremap('<leader>k', '<CMD>lua NvimTreeConfig.find_toggle()<CR>')

view.width = 40

nvimtree.setup {
  disable_netrw = true,
  hijack_netrw = true,
  auto_close = false,
  diagnostics = {
    enable = true
  },
  git = {
    enable = true,
    ignore = false
  },
  update_focused_file = {
    enable = true,
    update_cwd = false
  },
  view = {
    width = 40,
    side = 'left',
    auto_resize = true
  }
}
