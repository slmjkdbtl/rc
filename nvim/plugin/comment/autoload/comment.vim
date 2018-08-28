" wengwengweng

func! s:get_comment()

	let c = &commentstring

	return c

endfunc

func! s:is_commented(line)

	return a:line =~ substitute(s:get_comment(), '%s', '.*', '')

endfunc

func! s:comment(line)

	return substitute(s:get_comment(), '%s', a:line, '')

endfunc

func! s:uncomment(line)

	return substitute(a:line, substitute(s:get_comment(), '%s', '', ''), '', '')

endfunc

func! comment#toggle()

	let line = getline('.')

	if s:is_commented(line)
		call setline('.', s:uncomment(line))
	else
		call setline('.', s:comment(line))
	endif

endfunc

