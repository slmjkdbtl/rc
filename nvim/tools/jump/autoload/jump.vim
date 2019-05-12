" wengwengweng

func! s:options(list)
	return '\%(' . join(a:list, '\|') . '\)'
endfunc

func! jump#set(ft, patterns)
	let g:jump_marks[a:ft] = get(g:jump_marks, a:ft, s:options(a:patterns))
endfunc

func! s:jump(action)

	if a:action < 0
		let flag = 'b'
	else
		let flag = ''
	endif

	if !exists('b:jump_mark')
		return -1
	endif

	if search(b:jump_mark, flag)
		normal! zt
	endif

endfunc

func! jump#prev()
	return s:jump(-1)
endfunc

func! jump#next()
	return s:jump(1)
endfunc

noremap <silent> <plug>(jump_prev)
			\ :call jump#prev()<cr>

noremap <silent> <plug>(jump_next)
			\ :call jump#next()<cr>

