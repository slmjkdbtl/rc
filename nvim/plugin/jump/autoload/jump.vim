" wengwengweng

func! jump#set(ft, pattern)
	let g:jump_marks[a:ft] = get(g:jump_marks, a:ft, a:pattern)
endfunc

func! s:jump(action)

	if a:action < 0
		let flag = "b"
	else
		let flag = ""
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

