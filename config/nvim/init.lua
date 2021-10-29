local cmd = vim.cmd
local env = vim.env
local o = vim.o
local opt = vim.opt

-- Appearnce
o.termguicolors = true
opt.autoindent = true -- automatically indent new lines
opt.cmdheight = 1
opt.linebreak = true -- enable soft line wrapping
opt.number = true -- show line numbers
opt.scrolloff = 5 -- min number of lines to show above/below cursor while scrolling
opt.showcmd = true -- show (partial) commands in status line
opt.showmatch = true -- briefly highlight matching bracket on insert
opt.textwidth = 120 -- wrap line after specified number of characters
opt.title = true -- let vim set title of terminal window
opt.wrap = true -- enable line wrapping
opt.wrapmargin = 4 -- wrap line after specified number of characters from edge

opt.mouse = 'a' -- allow the mouse in all modes

-- Buffer management
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

require('plugins')

cmd('colorscheme dracula')
