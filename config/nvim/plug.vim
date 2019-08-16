" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'PeterRincker/vim-argumentative'
Plug 'SirVer/ultisnips'
Plug 'benekastah/neomake'
Plug 'chriskempson/base16-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'ervandew/supertab'
Plug 'LandonSchropp/vim-stamp'
Plug 'mhinz/vim-signify'
" Plug 'mwistrand/vim-predawn'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
" Plug 'valloric/youcompleteme'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Language-specific plugins
Plug 'ap/vim-css-color', { 'for': 'css' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'gregsexton/MatchTag', { 'for': 'html' }
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'leafgarland/typescript-vim', { 'for': ['typescript', 'typescript.tsx'] }
Plug 'ianks/vim-tsx'
Plug 'itspriddle/vim-marked', { 'for': 'markdown', 'on': 'MarkedOpen' }
Plug 'jason0x43/vim-js-indent', { 'for': [ 'javascript', 'typescript', 'html', 'jsp' ] }
Plug 'jason0x43/vim-js-syntax', { 'for': [ 'javascript', 'html' ] }
Plug 'kien/rainbow_parentheses.vim', { 'for': 'clojure' }
Plug 'mattn/emmet-vim'
Plug 'mxw/vim-jsx', { 'for': 'jsx' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure', 'on': 'FireplaceConnect' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'wavded/vim-stylus', { 'for': ['stylus', 'markdown'] }

if executable('go')
    Plug 'fatih/vim-go', { 'for': 'go' }
end

if executable('fzf') && has('nvim')
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
else
    Plug 'kien/ctrlp.vim'
endif

" Needs to be loaded at the end
Plug 'ryanoasis/vim-devicons'

call plug#end()
