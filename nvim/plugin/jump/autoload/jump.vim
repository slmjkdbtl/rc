" wengwengweng

func! jump#set(ft, pattern)
	let g:funcleads[a:ft] = get(g:funcleads, a:ft, a:pattern)
endfunc

func! jump#func(action)

	if a:action < 0
		let flag = "b"
	else
		let flag = ""
	endif

	if !exists('b:funclead')
		return -1
	endif

	if search(b:funclead, flag)
		normal! zt
	endif

endfunc

