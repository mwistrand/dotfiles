source ~/.config/nvim/plug.vim

" file type specific settings
if has('autocmd') && !exists('autocommands_loaded')
    let autocommands_loaded = 1
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType html setlocal ts=2 sts=2 sw=2 noexpandtab indentkeys-=*<return>
    autocmd FileType markdown,textile setlocal textwidth=0 wrapmargin=0 wrap
    autocmd FileType .xml exe ":silent %!xmllint --format --recover - 2>/dev/null"
    autocmd FileType crontab setlocal nobackup nowritebackup

    " save all files on focus lost, ignoring warnings about untitled buffers
    autocmd FocusLost * silent! wa

    autocmd BufNewFile,BufRead *.ejs set filetype=html
    autocmd BufNewFile,BufRead *.ino set filetype=c
    autocmd BufNewFile,BufRead *.svg set filetype=xml
    autocmd BufNewFile,BufRead *.dojorc* set filetype=json

    " make quickfix windows take all the lower section of the screen when there
    " are multiple windows open
    autocmd FileType qf wincmd J

    autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    let g:markdown_fenced_languages = ['css', 'javascript', 'js=javascript', 'json=javascript', 'stylus', 'html']

	" Remove whitespace for all files when saving
	autocmd BufWritePre * :%s/\s\+$//e

    autocmd! BufWritePost * Neomake
endif

syntax on
set encoding=utf-8

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
else
    set background=dark
    colorscheme predawn
endif

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
set tabstop=4 " the visible width of tabs
set softtabstop=4 " edit as if the tabs are 4 characters wide
set shiftwidth=4 " number of spaces to use for indent and unindent
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

" leader is a comma
let mapleader=','

" Plugin configuration

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

let g:neomake_javascript_jshint_maker = {
    \ 'args': ['--verbose'],
    \ 'errorformat': '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
\ }
autocmd FileType javascript let g:neomake_javascript_enabled_makers = findfile('.jshintrc', '.;') != '' ? ['jshint'] : ['eslint']

" Use project directory as root for CtrlP
let g:ctrlp_working_path_mode = 'ra'
" Open files in a new buffer
let g:ctrlp_switch_buffer = 0

" airline options
let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='base16'

" Ag options
let g:ag_working_path_mode="r"

" Silver Searcher settings
if executable('ag')
	" Use ag over grep
	set grepprg=ag\ --nogroup\ --nocolor

	" Use ag in CtrlP for listing files
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0

	nnoremap \ :Ag<SPACE>
endif

" fzf-specific settings
if executable('fzf') && has('nvim')
	map <silent> <leader>f :Files<CR>
	map <silent> <leader>g :GFiles<CR>
	map <silent> <leader>l :Lines<CR>
	map <silent> <leader>r :Buffers<CR>
	map <silent> <leader>s :BLines<CR>
endif

" YouCompleteMe settings
let g:ycm_error_symbol = '✖'
let g:ycm_warning_symbol = '⚠'
let g:ycm_filetype_blacklist = {
    \ 'tagbar' : 1,
    \ 'qf' : 1,
    \ 'notes' : 1,
    \ 'markdown' : 1,
    \ 'unite' : 1,
    \ 'text' : 1,
    \ 'vimwiki' : 1,
    \ 'pandoc' : 3,
    \ 'infolog' : 1,
    \ 'mail' : 1,
    \ 'gitcommit': 1
\ }

" UltiSnips
let g:UltiSnipsExpandTrigger = '<c-j>'
