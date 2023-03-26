local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt
local utils = require('utils')

local plugLoad = fn['functions#PlugLoad']
local plugBegin = fn['plug#begin']
local plugEnd = fn['plug#end']
local Plug = fn['plug#']

plugLoad()

plugBegin('~/.config/nvim/plugged')

-- Colorschemes
Plug 'dracula/vim'
Plug 'RRethy/nvim-base16'

-- Toggle comments with gcc
Plug 'tpope/vim-commentary'

-- VCS management
Plug 'tpope/vim-fugitive'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'

-- Toggle comments with gcc
Plug 'tpope/vim-commentary'

-- Indentation detection
Plug 'tpope/vim-sleuth'

-- Additional motions for working with the delete register
-- Plug 'LandonSchropp/vim-stamp'

-- Repeat last motion with `.`
Plug 'tpope/vim-repeat'

-- Use motions to easily change surrounding characters/tags
Plug 'tpope/vim-surround'

Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

local snippets_dir = os.getenv('DOTFILES') .. '/config/nvim/vsnip'
g.vsnip_snippet_dir = snippets_dir
utils.imap('<C-j>',"vsnip#expandable()?'<Plug>(vsnip-expand)':'<C-j>'", { expr = true })
utils.smap('<C-j>',"vsnip#expandable()?'<Plug>(vsnip-expand)':'<C-j>'", { expr = true })

-- File/buffer search settings: fzf
Plug('junegunn/fzf', {['dir'] = '~/.fzf', ['do'] = './install --all'})
Plug 'junegunn/fzf.vim'

-- Fuzzy finder
Plug 'nvim-telescope/telescope.nvim'

-- language server
Plug 'williamboman/mason.nvim' -- manage language servers
Plug 'williamboman/mason-lspconfig.nvim' -- automatically install language servers
Plug 'neovim/nvim-lspconfig'

-- completion
Plug 'davidsierradz/cmp-conventionalcommits'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind-nvim'

-- File tree
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

-- Status bar
Plug 'nvim-lualine/lualine.nvim'

-- Language-specific plugins
-- CSS
Plug('cakebaker/scss-syntax.vim', {['for'] = 'scss'})
Plug('hail2u/vim-css3-syntax', {['for'] = 'css'})
Plug('stephenway/postcss.vim', {['for'] = 'css'})
Plug('groenewege/vim-less', {['for'] = 'less'})
Plug('wavded/vim-stylus', {['for'] = {'stylus', 'markdown'}})

-- HTML, Markdown
Plug('gregsexton/MatchTag', {['for'] = 'html'})
Plug('itspriddle/vim-marked', {['for'] = 'markdown', ['on'] = 'MarkedOpen'})
Plug('tpope/vim-markdown', {['for'] = 'markdown'})
Plug('othree/html5.vim', {['for'] = 'html'})

-- JavaScript
Plug('elzr/vim-json', {['for'] = 'json'})
Plug('MaxMEllon/vim-jsx-pretty')
Plug('othree/yajs.vim', {['for'] = {'javascript', 'javascript.jsx', 'html'}})
Plug('moll/vim-node', {['for'] = 'javascript'})

-- TypeScript
Plug('leafgarland/typescript-vim', {['for'] = {'typescript', 'typescript.tsx'}})

-- Clojure
Plug('guns/vim-sexp', {['for'] =  'clojure'})
Plug('liquidz/vim-iced', {['for'] = 'clojure'})

g['iced#buffer#stdout#mods'] = 'rightbelow'
g['iced#cljs#default_env'] = 'shadow-cljs'
g['iced#nrepl#auto#does_switch_session'] = 'true'

-- Java
Plug('vim-test/vim-test', {['for'] = 'java'})
Plug('mfussenegger/nvim-dap')
Plug('mfussenegger/nvim-jdtls')

plugEnd()

if fn.executable('rg') then
	opt.grepprg = 'rg --vimgrep'
end

require('plugins.formatter')
require('plugins.fzf')
require('plugins.gitsigns')
require('plugins.lspconfig')
require('plugins.cmp')
require('plugins.jdtls')
require('plugins.lualine')
require('plugins.nvimtree')
require('plugins.telescope')
