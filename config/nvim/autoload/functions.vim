"" Attempt to install vim-plug if it is not already installed.
let s:plugpath = expand('<sfile>:p:h'). '/plug.vim'
function! functions#PlugCheck()
  if !filereadable(s:plugpath)
      if executable('curl')
          let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
          call system('curl -fLo ' . shellescape(s:plugpath) . ' --create-dirs ' . plugurl)
          if v:shell_error
              echom "Error downloading vim-plug. Please install it manually.\n"
              exit
          endif
      else
          echom "vim-plug not installed. Please install it manually or install curl.\n"
          exit
      endif
  endif
endfunction
