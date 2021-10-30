"" coc.nvim mappings {{{
  silent! nmap <LocalLeader>c :CocRestart<cr>

  "" Testing (<LocalLeader>t)
  nnoremap <LocalLeader>tt :call CocAction('runCommand', 'jest.singleTest')<CR>
  nnoremap <LocalLeader>tf :call CocAction('runCommand', 'jest.fileTest', ['%'])<CR>
  nnoremap <LocalLeader>ta :call CocAction('runCommand', 'jest.projectTest')<CR>
"" }}}
