" wengwengweng

func! s:options(list)
	return '\%(' . join(a:list, '\|') . '\)'
endfunc

func! s:match_get(str, pat)

	let bpat = substitute(a:pat, '%s', '.\+', '')
	let pats = split(a:pat, '%s')
	let pos1 = matchend(a:str, pats[0])
	let pos2 = match(a:str, pats[1]) - 1

	echo a:str[pos1:pos2]

endfunc

func! jump#set(ft, patterns)
	let g:jump_marks[a:ft] = get(g:jump_marks, a:ft, a:patterns)
endfunc

func! jump#search()

	if !has_key(g:jump_marks, &filetype)
		return
	endif

	let types = g:jump_marks[&filetype]

	for ty in keys(types)

		let pats = types[ty]

	endfor

endfunc

" func! s:jump(action)

" 	if a:action < 0
" 		let flag = 'b'
" 	else
" 		let flag = ''
" 	endif

" 	if !exists('b:jump_mark')
" 		return -1
" 	endif

" 	if search(b:jump_mark, flag)
" 		normal! zt
" 	endif

" endfunc

" func! jump#prev()
" 	return s:jump(-1)
" endfunc

" func! jump#next()
" 	return s:jump(1)
" endfunc

" noremap <silent> <plug>(jump_prev)
" 			\ :call jump#prev()<cr>

" noremap <silent> <plug>(jump_next)
" 			\ :call jump#next()<cr>

