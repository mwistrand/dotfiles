local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt
local utils = require('utils')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	-- Colorschemes
	'dracula/vim',
	'RRethy/nvim-base16',

	-- Toggle comments with gcc
	'tpope/vim-commentary',

	-- VCS management
	'tpope/vim-fugitive',
	'nvim-lua/plenary.nvim',
	'lewis6991/gitsigns.nvim',

	-- Toggle comments with gcc
	'tpope/vim-commentary',

	-- Indentation detection
	'tpope/vim-sleuth',

	-- Repeat last motion with `.`
	'tpope/vim-repeat',

	-- Use motions to easily change surrounding characters/tags
	'tpope/vim-surround',

	'hrsh7th/vim-vsnip',
	{
		'hrsh7th/vim-vsnip-integ',
		config = function()
			local snippets_dir = os.getenv('DOTFILES') .. '/config/nvim/vsnip'
			g.vsnip_snippet_dir = snippets_dir
			utils.imap('<C-j>',"vsnip#expandable()?'<Plug>(vsnip-expand)':'<C-j>'", { expr = true })
			utils.smap('<C-j>',"vsnip#expandable()?'<Plug>(vsnip-expand)':'<C-j>'", { expr = true })
		end
	},

	-- File/buffer search settings: fzf
	{ "junegunn/fzf.vim", dependencies = { { dir = vim.env.HOMEBREW_PREFIX .. "/opt/fzf" } } },


	-- Fuzzy finder
	'nvim-telescope/telescope.nvim',

	-- language server
	{ 'neovim/nvim-lspconfig', lazy = false },
	{
		'williamboman/mason.nvim', -- manage language servers,
		dependencies = {
			'williamboman/mason-lspconfig.nvim', -- automatically install language servers,
		},
	},

	-- completion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'davidsierradz/cmp-conventionalcommits',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-path',
			'onsails/lspkind-nvim',
		},
	},

	-- File tree
	'kyazdani42/nvim-web-devicons',
	'kyazdani42/nvim-tree.lua',

	-- Status bar
	'nvim-lualine/lualine.nvim',

	-- Language-specific plugins
	-- CSS
	{ 'cakebaker/scss-syntax.vim', ft = 'scss' },
	{ 'hail2u/vim-css3-syntax', ft = 'css' },
	{ 'stephenway/postcss.vim', ft = 'css' },
	{ 'groenewege/vim-less', ft = 'less' },
	{ 'wavded/vim-stylus', ft = { 'stylus', 'markdown' } },

	-- HTML, Markdown
	{ 'gregsexton/MatchTag', ft = 'html' },
	{ 'tpope/vim-markdown', ft = 'markdown' },
	{ 'othree/html5.vim', ft = 'html' },

	-- JavaScript
	{ 'elzr/vim-json', ft = 'json' },
	'MaxMEllon/vim-jsx-pretty',
	{ 'othree/yajs.vim', ft = { 'javascript', 'javascript.jsx', 'html' } },
	{ 'moll/vim-node', ft = 'javascript' },

	-- TypeScript
	{ 'leafgarland/typescript-vim', ft = { 'typescript', 'typescript.tsx' } },

	-- Clojure
	{ 'guns/vim-sexp', ft =  'clojure' },
	{
		'liquidz/vim-iced',
		ft = 'clojure',
		config = function()
			g['iced#buffer#stdout#mods'] = 'rightbelow'
			g['iced#cljs#default_env'] = 'shadow-cljs'
			g['iced#nrepl#auto#does_switch_session'] = 'true'
		end
	},

	-- Java
	-- { 'vim-test/vim-test', ft = 'java' },
	'mfussenegger/nvim-dap',
	'mfussenegger/nvim-jdtls',
})

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
