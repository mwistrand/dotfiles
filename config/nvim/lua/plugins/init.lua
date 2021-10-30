local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt
local utils = require('utils')

local plugLoad = fn['functions#PlugLoad']
local plugBegin = fn['plug#begin']
local plugEnd = fn['plug#end']

plugLoad()

plugBegin('~/.config/nvim/plugged')

-- Colorschemes
cmd [[Plug 'dracula/vim']]

-- Toggle comments with gcc
cmd [[Plug 'tpope/vim-commentary']]

-- VCS management
cmd [[Plug 'mhinz/vim-signify']]
cmd [[Plug 'tpope/vim-fugitive']]

-- Toggle comments with gcc
cmd [[Plug 'tpope/vim-commentary']]

-- Indentation detection
cmd [[Plug 'tpope/vim-sleuth']]

-- Additional motions for working with the delete register
cmd [[Plug 'LandonSchropp/vim-stamp']]

-- Repeat last motion with `.`
cmd [[Plug 'tpope/vim-repeat']]

-- Use motions to easily change surrounding characters/tags
cmd [[Plug 'tpope/vim-surround']]

-- File/buffer search settings: fzf
cmd [[Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }]]
cmd [[Plug 'junegunn/fzf.vim']]

-- coc.nvim
cmd [[Plug 'neoclide/coc.nvim', {'branch': 'release', 'for': ['javascript', 'typescript', 'typescript.tsx', 'css', 'java']}]]

-- File tree
cmd [[Plug 'kyazdani42/nvim-web-devicons']]
cmd [[Plug 'kyazdani42/nvim-tree.lua']]

-- Language-specific plugins
-- CSS
cmd [[Plug 'ap/vim-css-color', { 'for': 'css' }]]
cmd [[Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }]]
cmd [[Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }]]
cmd [[Plug 'groenewege/vim-less', { 'for': 'less' }]]
cmd [[Plug 'wavded/vim-stylus', { 'for': ['stylus', 'markdown'] }]]

-- HTML, Markdown
cmd [[Plug 'gregsexton/MatchTag', { 'for': 'html' }]]
cmd [[Plug 'itspriddle/vim-marked', { 'for': 'markdown', 'on': 'MarkedOpen' }]]
cmd [[Plug 'tpope/vim-markdown', { 'for': 'markdown' }]]
cmd [[Plug 'othree/html5.vim', { 'for': 'html' }]]

-- JavaScript
cmd [[Plug 'elzr/vim-json', { 'for': 'json' }]]
cmd [[Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'html'] }]]
cmd [[Plug 'MaxMEllon/vim-jsx-pretty']]

-- TypeScript
cmd [[Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescript.tsx'] }]]

-- Clojure
cmd [[Plug 'guns/vim-sexp', { 'for': 'clojure' }]]
cmd [[Plug 'liquidz/vim-iced', { 'for': 'clojure' }]]

g['iced#buffer#stdout#mods'] = 'rightbelow'
g['iced#cljs#default_env'] = 'shadow-cljs'
g['iced#nrepl#auto#does_switch_session'] = 'true'

-- Java
cmd [[Plug 'vim-test/vim-test', { 'for': 'java' }]]

-- Go
if fn.executable('go') then
	cmd [[Plug 'fatih/vim-go', { 'for': 'go' }]]
end

plugEnd()

if fn.executable('rg') then
	opt.grepprg = 'rg --vimgrep'
end

require('plugins.coc')
require('plugins.formatter')
require('plugins.fzf')
require('plugins.nerdtree')
