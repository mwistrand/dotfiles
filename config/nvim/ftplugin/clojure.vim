"" vim-iced mappings {{{
  silent! nmap <buffer> <LocalLeader>c <Plug>(iced_connect)

  "" Evaluating (<LocalLeader>e)
  silent! nmap <buffer> <LocalLeader>eq <Plug>(iced_interrupt)
  silent! nmap <buffer> <LocalLeader>ei <Plug>(iced_eval)<Plug>(sexp_inner_element)``
  silent! nmap <buffer> <LocalLeader>ee <Plug>(iced_eval)<Plug>(sexp_outer_list)``
  silent! nmap <buffer> <LocalLeader>et <Plug>(iced_eval_outer_top_list)
  silent! nmap <buffer> <LocalLeader>en <Plug>(iced_eval_ns)
  silent! vmap <buffer> <LocalLeader>ee <Plug>(iced_eval_visual)
  silent! nmap <buffer> <LocalLeader>ep <Plug>(iced_print_last)
  silent! nmap <buffer> <LocalLeader>eb <Plug>(iced_require)
  silent! nmap <buffer> <LocalLeader>eB <Plug>(iced_require_all)
  silent! nmap <buffer> <LocalLeader>eu <Plug>(iced_undef)
  silent! nmap <buffer> <LocalLeader>eM <Plug>(iced_macroexpand_outer_list)
  silent! nmap <buffer> <LocalLeader>em <Plug>(iced_macroexpand_1_outer_list)

  "" Refactoring (<LocalLeader>r)
  silent! nmap <buffer> <LocalLeader>rcn <Plug>(iced_clean_ns)
  silent! nmap <buffer> <LocalLeader>rca <Plug>(iced_clean_all)
  silent! nmap <buffer> <LocalLeader>ram <Plug>(iced_add_missing)
  silent! nmap <buffer> <LocalLeader>ran <Plug>(iced_add_ns)
  silent! nmap <buffer> <LocalLeader>rtf <Plug>(iced_thread_first)
  silent! nmap <buffer> <LocalLeader>rtl <Plug>(iced_thread_last)
  silent! nmap <buffer> <LocalLeader>ref <Plug>(iced_extract_function)
  silent! nmap <buffer> <LocalLeader>raa <Plug>(iced_add_arity)
  silent! nmap <buffer> <LocalLeader>rml <Plug>(iced_move_to_let)

  "" Testing (<LocalLeader>t)
  silent! nmap <buffer> <LocalLeader>tt <Plug>(iced_test_under_cursor)
  silent! nmap <buffer> <LocalLeader>tl <Plug>(iced_test_rerun_last)
  silent! nmap <buffer> <LocalLeader>ts <Plug>(iced_test_spec_check)
  silent! nmap <buffer> <LocalLeader>to <Plug>(iced_test_buffer_open)
  silent! nmap <buffer> <LocalLeader>tn <Plug>(iced_test_ns)
  silent! nmap <buffer> <LocalLeader>ta <Plug>(iced_test_all)
  silent! nmap <buffer> <LocalLeader>tr <Plug>(iced_test_redo)

  "" Help/Document (<LocalLeader>h)
  silent! nmap <buffer> K <Plug>(iced_popup_document_open)
  silent! nmap <buffer> <LocalLeader>hq <Plug>(iced_document_close)
  silent! nmap <buffer> <LocalLeader>hs <Plug>(iced_popup_source_show)
  silent! nmap <buffer> <LocalLeader>hc <Plug>(iced_clojuredocs_open)
  silent! nmap <buffer> <LocalLeader>hh <Plug>(iced_command_palette)

  "" Browsing (<LocalLeader>b)
  silent! nmap <buffer> <LocalLeader>bs <Plug>(iced_browse_spec)
  silent! nmap <buffer> <LocalLeader>bt <Plug>(iced_browse_test_under_cursor)
  silent! nmap <buffer> <LocalLeader>br <Plug>(iced_browse_references)
  silent! nmap <buffer> <LocalLeader>bd <Plug>(iced_browse_dependencies)

  "" Jumping cursor (<LocalLeader>j)
  silent! nmap <buffer> <C-]> <Plug>(iced_def_jump)
  silent! nmap <buffer> <C-t> <Plug>(iced_def_back)
  silent! nmap <buffer> <LocalLeader>jl <Plug>(iced_jump_to_let)

  "" Misc
  silent! nmap <buffer> == <Plug>(iced_format)
  silent! nmap <buffer> =G <Plug>(iced_clean_all)

  "" Clean and format on save
  function! CleanAll()
    if iced#nrepl#is_connected()
      call iced#nrepl#refactor#clean_all()
    endif
  endfunction
  autocmd BufWrite * silent! call CleanAll()
"" }}}
