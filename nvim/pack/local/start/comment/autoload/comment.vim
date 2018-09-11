" wengwengweng

func! s:is_commented(line)

	return a:line =~ substitute(&commentstring, '%s', '.*', '')

endfunc

func! s:comment(line)

	return substitute(&commentstring, '%s', escape(a:line, '&\.'), '')

endfunc

func! s:uncomment(line)

	return substitute(a:line, substitute(&commentstring, '%s', '', ''), '', '')

endfunc

func! comment#toggle()

	let line = getline('.')

	if s:is_commented(line)
		call setline('.', s:uncomment(line))
	else
		call setline('.', s:comment(line))
	endif

endfunc

noremap <silent> <Plug>(comment_toggle)
			\ :call comment#toggle()<cr>

