"" coc.nvim mappings {{{
  silent! nmap <LocalLeader>c :CocRestart<cr>
  silent! nmap <silent> <LocalLeader>x :CocCommand java.clean.workspace<cr>

  "" compilation commands
  silent! nmap <silent> <LocalLeader>jc :!javac %<CR>
  silent! nmap <silent> <LocalLeader>b :CocCommand java.workspace.compile<cr>

  ""refactoring commands
  silent! nmap <silent> <LocalLeader>rn <Plug>(coc-rename)
  silent! nmap <silent> <LocalLeader>ri :CocCommand java.action.organizeImports<cr>

  "" navigation commands
  silent! nmap <silent> <LocalLeader>gd Plug(coc-definition)
"" }}}
