setlocal textwidth=0 wrapmargin=0 wrap

let g:goyo_width = 120

function! s:goyo_enter()
	call v:lua.require('lualine').hide()
endfunction

function! s:goyo_leave()
	:silent execute "v:lua.require('lualine').hide({unhide=true})"
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
