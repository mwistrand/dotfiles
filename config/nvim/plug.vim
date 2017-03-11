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

Plug 'kien/ctrlp.vim'
Plug 'mwistrand/vim-predawn'
Plug 'chriskempson/base16-vim'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'benekastah/neomake'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-commentary'
Plug 'PeterRincker/vim-argumentative'
Plug 'Raimondi/delimitMate'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-surround'
Plug 'ervandew/supertab'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'ElmCast/elm-vim'

" Language-specific plugins
Plug 'gregsexton/MatchTag', { 'for': 'html' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'ap/vim-css-color', { 'for': 'css' }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'wavded/vim-stylus', { 'for': ['stylus', 'markdown'] }
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'jason0x43/vim-tss', { 'for': 'typescript', 'do': 'npm install' }
Plug 'jason0x43/vim-js-indent', { 'for': [ 'javascript', 'typescript', 'html', 'jsp' ] }
Plug 'jason0x43/vim-js-syntax', { 'for': [ 'javascript', 'html' ] }
Plug 'mxw/vim-jsx', { 'for': 'jsx' }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'itspriddle/vim-marked', { 'for': 'markdown', 'on': 'MarkedOpen' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }

if executable('go')
	Plug 'fatih/vim-go', { 'for': 'go' }
end

call plug#end()
