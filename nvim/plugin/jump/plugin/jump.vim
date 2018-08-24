" wengwengweng

let g:jump_marks = get(g:, 'jump_marks', {})

call jump#set('lua', 'function\s.\+(.*)')
call jump#set('javascript', '\w\+(\w*)\s{')
call jump#set('vim', 'fu\%[nction]!\s.\+(.*)')
call jump#set('make', '^[^.]\w\+:')
call jump#set('markdown', '^#\%[#####]')
call jump#set('css', '\S*\s{')
call jump#set('scss', '\S*\s{')
call jump#set('pug', '\w*(.*)')
call jump#set('rust', 'fn\s.*(.*)')

augroup JumpMarks

	autocmd!

	for [ key, val ] in items(g:jump_marks)
		exec "autocmd FileType " . key . " let b:jump_mark = '" . val . "'"
	endfor

augroup END

command! PrevMark
			\ call jump#prev()

command! NextMark
			\ call jump#next()

