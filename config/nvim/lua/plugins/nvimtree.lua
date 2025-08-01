-- Thanks, Nick! https://github.com/nicknisi/dotfiles/blob/master/config/nvim/lua/plugins/nvimtree.lua
local nvimtree = require('nvim-tree')
local nnoremap = require('utils').nnoremap

nnoremap('<leader>k', ':NvimTreeToggle<cr>')

local function on_attach(bufnr)
  local api = require('nvim-tree.api')
  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.del('n', '<C-e>', { buffer = bufnr })
end

nvimtree.setup({
  on_attach = on_attach,
  disable_netrw = false,
  hijack_netrw = true,
  diagnostics = {
    enable = false,
    icons = {
      hint = '',
      info = '',
      warning = '',
      error = ''
    }
  },
  renderer = {
    add_trailing = false,
    group_empty = true,
    highlight_git = true,
    highlight_opened_files = "all",
    indent_markers = {
      enable = true
    },
    icons = {
      glyphs = {
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
        }
      }
    }
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
  }
})
