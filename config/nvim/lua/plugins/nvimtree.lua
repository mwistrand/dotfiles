-- Thanks, Nick! https://github.com/nicknisi/dotfiles/blob/master/config/nvim/lua/plugins/nvimtree.lua
local nvimtree = require('nvim-tree')
local nnoremap = require('utils').nnoremap

local view = require('nvim-tree.view')
_G.NvimTreeConfig = {}

function NvimTreeConfig.find_toggle()
  if view.is_visible() then
    view.close()
  else
    vim.cmd('NvimTreeToggle')
  end
end

nnoremap('<leader>k', '<CMD>lua NvimTreeConfig.find_toggle()<CR>')

view.width = 40

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
