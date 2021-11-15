local cmd = vim.cmd
local env = vim.env
local fn = vim.fn
local g = vim.g
local o = vim.o
local opt = vim.opt
local utils = require('utils')

-- Appearnce
o.termguicolors = true
opt.autoindent = true -- automatically indent new lines
opt.cmdheight = 1
opt.linebreak = true -- enable soft line wrapping
opt.number = true -- show line numbers
opt.scrolloff = 5 -- min number of lines to show above/below cursor while scrolling
opt.showcmd = true -- show (partial) commands in status line
opt.showmatch = true -- briefly highlight matching bracket on insert
opt.showmode = false -- don't show the mode since it's displayed by the status line plugin
opt.textwidth = 120 -- wrap line after specified number of characters
opt.title = true -- let vim set title of terminal window
opt.wrap = true -- enable line wrapping
opt.wrapmargin = 4 -- wrap line after specified number of characters from edge

opt.mouse = 'a' -- allow the mouse in all modes

-- Buffer management
o.hidden = true -- allow hidden buffers with unsaved work
opt.backup = false -- disable backups when saving files
opt.swapfile = false -- don't create swap files
opt.timeoutlen = 1000 -- mapped sequence timeout
opt.writebackup = false -- don't write a backup before saving

-- Tab management
opt.shiftround = true -- use multiples of opt.shiftwidth when indenting
opt.shiftwidth = 4 -- number of spaces to use when indenting
opt.smarttab = true -- use 'shiftwidth' when inserting <Tab>
opt.softtabstop = -1 -- match value of shiftwidth
opt.tabstop = 4

-- Invisible characters
opt.list = true
opt.listchars = {
  tab = "→ ",
  eol = "¬",
  trail = "⋅",
  extends = "❯",
  precedes = "❮"
}
opt.showbreak = "↪"

-- Searching
opt.hlsearch = true -- highlight search results
opt.ignorecase = true
opt.incsearch = true -- display incremental search results
opt.lazyredraw = true -- do not redraw while executing macros
opt.magic = true -- defaults to on, but explicit here to not break plugins
opt.smartcase = true

opt.clipboard = {"unnamed", "unnamedplus"}

opt.history = 1000 -- only remember the last 1,000 commands
opt.shell = env.SHELL

-- Error bells
opt.errorbells = false
opt.visualbell = true

-- Scroll the viewport faster
utils.nnoremap('<C-e>', '3<C-e>')
utils.nnoremap('<C-y>', '3<C-y>')

-- Navigate through soft line breaks in a way that doesn't break <vcount>
utils.nnoremap('j', 'v:count == 0 ? "gj" : "j"', {expr = true})
utils.nnoremap('k', 'v:count == 0 ? "gk" : "k"', {expr = true})
utils.nnoremap('^', 'v:count == 0 ? "g^" :  "^"', {expr = true})
utils.nnoremap('$', 'v:count == 0 ? "g$" : "$"', {expr = true})

-- General mappings are triggered with a comma, while mappings that are file
-- type-specific are triggered with a colon.
g.mapleader = ','
g.maplocalleader = ';'

-- Buffer navigation
utils.map('<Leader><Leader>', ':b#<cr>')

require('plugins')

if fn.filereadable(fn.expand('~/.vimrc_background')) then
    g.base16colorspace = 256
    cmd [[source ~/.vimrc_background]]
else
  cmd('colorscheme dracula')
end
