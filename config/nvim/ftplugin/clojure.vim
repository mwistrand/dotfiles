"" vim-iced mappings {{{
  silent! nmap <buffer> <Leader>c <Plug>(iced_connect)

  "" Evaluating (<Leader>e)
  silent! nmap <buffer> <Leader>eq <Plug>(iced_interrupt)
  silent! nmap <buffer> <Leader>ei <Plug>(iced_eval)<Plug>(sexp_inner_element)``
  silent! nmap <buffer> <Leader>ee <Plug>(iced_eval)<Plug>(sexp_outer_list)``
  silent! vmap <buffer> <Leader>ee <Plug>(iced_eval_visual)
  silent! nmap <buffer> <Leader>ep <Plug>(iced_print_last)
  silent! nmap <buffer> <Leader>eb <Plug>(iced_require)
  silent! nmap <buffer> <Leader>eB <Plug>(iced_require_all)
  silent! nmap <buffer> <Leader>eu <Plug>(iced_undef)
  silent! nmap <buffer> <Leader>eM <Plug>(iced_macroexpand_outer_list)
  silent! nmap <buffer> <Leader>em <Plug>(iced_macroexpand_1_outer_list)

  "" Testing (<Leader>t)
  silent! nmap <buffer> <Leader>tt <Plug>(iced_test_under_cursor)
  silent! nmap <buffer> <Leader>tl <Plug>(iced_test_rerun_last)
  silent! nmap <buffer> <Leader>ts <Plug>(iced_test_spec_check)
  silent! nmap <buffer> <Leader>to <Plug>(iced_test_buffer_open)
  silent! nmap <buffer> <Leader>tn <Plug>(iced_test_ns)
  silent! nmap <buffer> <Leader>tp <Plug>(iced_test_all)
  silent! nmap <buffer> <Leader>tr <Plug>(iced_test_redo)

  "" Help/Document (<Leader>h)
  silent! nmap <buffer> K <Plug>(iced_popup_document_open)
  silent! nmap <buffer> <Leader>hq <Plug>(iced_document_close)
  silent! nmap <buffer> <Leader>hs <Plug>(iced_popup_source_show)
  silent! nmap <buffer> <Leader>hc <Plug>(iced_clojuredocs_open)
  silent! nmap <buffer> <Leader>hh <Plug>(iced_command_palette)

  "" Browsing (<Leader>b)
  silent! nmap <buffer> <Leader>bs <Plug>(iced_browse_spec)
  silent! nmap <buffer> <Leader>bt <Plug>(iced_browse_test_under_cursor)
  silent! nmap <buffer> <Leader>br <Plug>(iced_browse_references)
  silent! nmap <buffer> <Leader>bd <Plug>(iced_browse_dependencies)

  "" Jumping cursor (<Leader>j)
  silent! nmap <buffer> <C-]> <Plug>(iced_def_jump)
  silent! nmap <buffer> <C-t> <Plug>(iced_def_back)
  silent! nmap <buffer> <Leader>jl <Plug>(iced_jump_to_let)

  "" Misc
  silent! nmap <buffer> == <Plug>(iced_format)
"" }}}
