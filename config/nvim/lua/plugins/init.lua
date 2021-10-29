local cmd = vim.cmd
local fn = vim.fn

local plugLoad = fn['functions#PlugLoad']
local plugBegin = fn['plug#begin']
local plugEnd = fn['plug#end']

plugLoad()

plugBegin('~/.config/nvim/plugged')

cmd [[Plug 'dracula/vim']]

plugEnd()
