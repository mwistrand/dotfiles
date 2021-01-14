" check whether vim-plug is installed and install it if necessary
call functions#PlugCheck()
" Plugins
call plug#begin('~/.vim/plugged')

"" General Vim settings {{{
	syntax on
	set encoding=utf-8

	" make the highlighting of tabs and other non-text less annoying
	highlight SpecialKey ctermbg=none ctermfg=8
	highlight NonText ctermbg=none ctermfg=8

	" make comments and HTML attributes italic
	highlight Comment cterm=italic
	highlight htmlArg cterm=italic

	" allow modified buffers to be hidden
	set hidden

	" Tab control
	set noexpandtab " insert tabs rather than spaces for <Tab>
	set smarttab " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
	set tabstop=2 " the visible width of tabs
	set softtabstop=2 " edit as if the tabs are 2 characters wide
	set shiftwidth=2 " number of spaces to use for indent and unindent
	set shiftround " round indent to a multiple of 'shiftwidth'
	set completeopt+=longest
	set completeopt-=preview " Disable the autocomplete preview window

	" code folding settings
	set foldmethod=syntax " fold based on indent
	set foldnestmax=10 " deepest fold is 10 levels
	set nofoldenable " don't fold by default
	set foldlevel=1

	set title " set terminal title

	" Searching
	set ignorecase " case insensitive searching
	set smartcase " case-sensitive if expresson contains a capital letter
	set hlsearch
	set incsearch " set incremental search, like modern browsers
	set lazyredraw " don't redraw while executing macros

	set showmatch

	" error bells
	set noerrorbells
	set visualbell

	set ruler
	set number

	set wrap "turn on line wrapping
	set wrapmargin=8 " wrap lines when coming within n characters from side
	set linebreak " set soft wrapping
	set showbreak=… " show ellipsis at breaking

	set autoindent " automatically set indent of new line
	set smartindent

	set cursorline " highlight the current line

	" toggle invisible characters
	set list
	set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
	set showbreak=↪

	" scroll the viewport faster
	nnoremap <C-e> 3<C-e>
	nnoremap <C-y> 3<C-y>

	" moving up and down work as you would expect
	nnoremap <silent> j gj
	nnoremap <silent> k gk
	nnoremap <silent> ^ g^
	nnoremap <silent> $ g$

	" move to the beginning/end of the line
	nnoremap <silent> B ^
	nnoremap <silent> E $

	" Umap ^/$
	nnoremap ^ <nop>
	nnoremap $ <nop>

	" General mappings are triggered with a comma, while mappings that are file
	" type-specific are triggered with a colon.
	let mapleader=','
	let maplocalleader=';'

	" Open the (n)vim config from anywhere
	noremap <Leader>ev :e! $MYVIMRC<cr>

	" Quickly generate the help tags for this repo
	map <Leader>hs :helptags $HOME/.dotfiles/config/nvim/doc<cr>
	" View the cheatsheet for this repo
	map <Leader>hh :h dotfiles<cr>

	map <Leader>tt :tabe<cr>
	map <Leader>tf :tabfirst<cr>
	map <Leader>tc :tabclose<cr>
	map <Leader>to :tabonly<cr>

	map <Leader><Leader> :b#<cr>

	"" file type specific settings {{{
		augroup AutoCmdSettings
			autocmd!

			" Reload vim config on save
			autocmd BufWritePost .vimrc,init.vim source %

			" save all files on focus lost, ignoring warnings about untitled buffers
			autocmd FocusLost * silent! wa

			" make quickfix windows take all the lower section of the screen
			" when there are multiple windows open
			autocmd FileType qf wincmd J
			autocmd FileType qf nmap <buffer> q :q<cr>

			" Remove whitespace for all files when saving
			autocmd BufWritePre * :%s/\s\+$//e
		augroup END
	"" }}}
"" }}}

"" General Plugins {{{
	"" colorschemes
	Plug 'chriskempson/base16-vim'
	Plug 'mwistrand/vim-predawn'

	"" Motions to swap argument order
	Plug 'PeterRincker/vim-argumentative'

	"" .editorconfig support
	Plug 'editorconfig/editorconfig-vim'

	"" VCS management
	Plug 'mhinz/vim-signify'
	Plug 'tpope/vim-fugitive'

	"" Toggle comments with gcc
	Plug 'tpope/vim-commentary'

	"" Indentation detection
	Plug 'tpope/vim-sleuth'

	"" Additional motions for working with the delete register
	Plug 'LandonSchropp/vim-stamp'

	"" Repeat last motion with `.`
	Plug 'tpope/vim-repeat'

	"" Use motions to easily change surrounding characters/tags
	Plug 'tpope/vim-surround'

	"" File/buffer search settings: fzf {{{
		Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
		Plug 'junegunn/fzf.vim'

		map <silent> <leader>l :Lines<CR>
		map <silent> <leader>r :Buffers<CR>
		map <silent> <leader>s :BLines<CR>
	"" }}}

	"" YouCompleteMe graveyard {{{
	" let g:ycm_error_symbol = '✖'
	" let g:ycm_warning_symbol = '⚠'
	" let g:ycm_filetype_blacklist = {
	"     \ 'tagbar' : 1,
	"     \ 'qf' : 1,
	"     \ 'notes' : 1,
	"     \ 'markdown' : 1,
	"     \ 'unite' : 1,
	"     \ 'text' : 1,
	"     \ 'vimwiki' : 1,
	"     \ 'pandoc' : 3,
	"     \ 'infolog' : 1,
	"     \ 'mail' : 1,
	"     \ 'gitcommit': 1
	" \ }
	"" }}}

	"" coc.nvim {{{
		Plug 'neoclide/coc.nvim', {'branch': 'release', 'for': ['javascript', 'typescript', 'typescript.tsx', 'css', 'java']}

		" coc settings
		let g:coc_global_extensions = [
			\ 'coc-css',
			\ 'coc-emmet',
			\ 'coc-emoji',
			\ 'coc-eslint',
			\ 'coc-java',
			\ 'coc-jest',
			\ 'coc-json',
			\ 'coc-pairs',
			\ 'coc-prettier',
			\ 'coc-svg',
			\ 'coc-tslint-plugin',
			\ 'coc-tsserver',
			\ 'coc-yaml',
			\ ]

		" use coc.nvim for goto shortcuts
		nmap <silent> gf <Plug>(coc-definition)
		nmap <silent> gi <Plug>(coc-implementation)
		nmap <silent> gr <Plug>(coc-references)

		" Use tab for trigger completion with characters ahead and navigate.
		" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
		inoremap <silent><expr> <TAB>
					\ pumvisible() ? "\<C-n>" :
					\ <SID>check_back_space() ? "\<TAB>" :
					\ coc#refresh()
		inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

		function! s:check_back_space() abort
			let col = col('.') - 1
			return !col || getline('.')[col - 1]  =~# '\s'
		endfunction
	"" }}}

	"" UltiSnips {{{
		" Plug 'SirVer/ultisnips'

		" let g:UltiSnipsExpandTrigger = '<C-l>'
	"" }}}

	"" NERDTree {{{
		Plug 'scrooloose/nerdtree'
		Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
		Plug 'ryanoasis/vim-devicons'

		" close NERDTree after a file is opened
		let g:NERDTreeQuitOnOpen=1
		" show hidden files in NERDTree
		let NERDTreeShowHidden=1
		" Set the default NERDTree width
		:let g:NERDTreeWinSize=50

		" Toggle NERDTree
		nmap <silent> <leader>k :NERDTreeToggle<cr>
		" display the current file in NERDTree
		nmap <silent> <leader>n :NERDTreeFind<cr>
	"" }}}

	"" Airline {{{
		Plug 'vim-airline/vim-airline'
		Plug 'vim-airline/vim-airline-themes'

		let g:airline_powerline_fonts=1
		let g:airline_left_sep=''
		let g:airline_right_sep=''
		let g:airline_theme='base16'
	"" }}}
"" }}}

"" Language-specific plugins {{{
	"" CSS {{{
		Plug 'ap/vim-css-color', { 'for': 'css' }
		Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
		Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
		Plug 'groenewege/vim-less', { 'for': 'less' }
		Plug 'wavded/vim-stylus', { 'for': ['stylus', 'markdown'] }
	"" }}}

	"" HTML, Markdown {{{
		Plug 'gregsexton/MatchTag', { 'for': 'html' }
		Plug 'itspriddle/vim-marked', { 'for': 'markdown', 'on': 'MarkedOpen' }
		Plug 'tpope/vim-markdown', { 'for': 'markdown' }
		Plug 'othree/html5.vim', { 'for': 'html' }
	"" }}}

	"" JavaScript {{{
		Plug 'elzr/vim-json', { 'for': 'json' }
		Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'html'] }
		Plug 'MaxMEllon/vim-jsx-pretty'
	"" }}}

	"" TypeScript {{{
		Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescript.tsx'] }
	"" }}}

	"" Clojure {{{
		"" Graveyard {{{
			" Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
			" Plug 'kien/rainbow_parentheses.vim', { 'for': 'clojure' }
			" Plug 'tpope/vim-fireplace', { 'for': 'clojure', 'on': 'FireplaceConnect' }
			" Plug 'kovisoft/paredit', {'for': ['clojure']}
			" Plug 'bhurlow/vim-parinfer', {'for': ['clojure']}
		"" }}}

			Plug 'guns/vim-sexp', { 'for': 'clojure' }
			Plug 'liquidz/vim-iced', { 'for': 'clojure' }

			let g:iced#buffer#stdout#mods = 'rightbelow'
			let g:iced#cljs#default_env = 'shadow-cljs'
			let g:iced#nrepl#auto#does_switch_session = 'true'
	"" }}}

	"" Go {{{
		if executable('go')
			Plug 'fatih/vim-go', { 'for': 'go' }
		end
	"" }}}
"" }}}

call plug#end()

"" ripgrep {{{
	if executable('rg')
		command! -bang -nargs=* Find call fzf#vim#grep(
			\ 'rg --smart-case --column --line-number --no-heading --follow --color=always '.<q-args>, 1,
			\ <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)

		command! -bang -nargs=? -complete=dir Files
			\ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:50%', '?'), <bang>0)

		command! -bang -nargs=? -complete=dir GitFiles
			\ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview('right:50%', '?'), <bang>0)

		" Use ripgrep over grep
		set grepprg=rg\ --vimgrep

		nnoremap \ :Find<SPACE>
		map <silent> <leader>f :Files<CR>
		map <silent> <leader>g :GitFiles<CR>
	end
"" }}}

"" Must be placed after plug#end to ensure colorscheme is set correctly.
if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
else
	set background=dark
	colorscheme predawn
endif
