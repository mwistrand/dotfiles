"" coc.nvim mappings {{{
  silent! nmap <silent> <LocalLeader>c :CocCommand java.clean.workspace<cr>
  silent! nmap <silent> <LocalLeader>l :CocCommand java.open.serverLog<cr>

  "" compilation commands
  silent! nmap <silent> <LocalLeader>jc :!javac %<CR>
  silent! nmap <silent> <LocalLeader>b :CocCommand java.workspace.compile<cr>

  ""refactoring commands
  silent! nmap <silent> <LocalLeader>rn <Plug>(coc-rename)
  silent! nmap <silent> <LocalLeader>ri :CocCommand java.action.organizeImports<cr>

  silent! nmap <silent> <LocalLeader>ac <Plug>(coc-codeaction)
  silent! nmap <silent> <LocalLeader>qf <Plug>(coc-fix-current)

  "" navigation commands
  silent! nmap <silent> <LocalLeader>gd Plug(coc-definition)

  "" test commands (requires on vim-test)
  silent! nmap <silent> <LocalLeader>tn :TestNearest<cr>
  silent! nmap <silent> <LocalLeader>tf :TestFile<cr>
  silent! nmap <silent> <LocalLeader>ts :TestSuite<cr>
  silent! nmap <silent> <LocalLeader>tl :TestLast<cr>
  silent! nmap <silent> <LocalLeader>tg :TestVisit<cr>
"" }}}
