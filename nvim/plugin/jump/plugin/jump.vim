" wengwengweng

let g:funcleads = get(g:, 'funcleads', {})

call jump#set('lua', 'function\s.\+(.*)')
call jump#set('javascript', '\w\+(\w*)\s{')
call jump#set('vim', 'fu\%[nction]!\s.\+(.*)')
call jump#set('make', '^[^.]\w\+:')
call jump#set('markdown', '^#\%[#####]')
call jump#set('css', '\S*\s{')
call jump#set('scss', '\S*\s{')
call jump#set('pug', '\w*(.*)')
call jump#set('rust', 'fn\s.*(.*)')

augroup funcleads

	autocmd!

	for [ key, val ] in items(g:funcleads)
		exec "autocmd FileType " . key . " let b:funclead = '" . val . "'"
	endfor

augroup END

command! PrevFunc :call jump#func(-1)
command! NextFunc :call jump#func(1)

