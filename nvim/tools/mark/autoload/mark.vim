" wengwengweng

func! s:options(list)
	return '\%(' . join(a:list, '\|') . '\)'
endfunc

func! s:capture(str, pat)
	return matchstr(a:str, s:tpat(a:pat))
endfunc

func! mark#set(ft, patterns)
	let g:marks[a:ft] = get(g:marks, a:ft, a:patterns)
endfunc

func! mark#search()

	if !has_key(g:marks, &filetype)
		return
	endif

	let types = g:marks[&filetype]

	for ty in keys(types)
		let pats = types[ty]
	endfor

endfunc

func! mark#jump_prev()
endfunc

func! mark#jump_next()
endfunc

noremap <silent> <plug>(mark_jump_prev)
			\ :call mark#jump_prev()<cr>

noremap <silent> <plug>(mark_jump_next)
			\ :call mark#jump_next()<cr>

