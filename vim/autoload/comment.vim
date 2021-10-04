func! comment#is_commented(line)
	if comment#is_wrap()
		" TODO
		return 0
	else
		return a:line =~# '^' . substitute(&cms, '%s$', '', '')
	endif
endfunc

func! comment#is_wrap()
	return &cms !~# '%s$'
endfunc

func! comment#comment(line)

	if empty(a:line) || comment#is_commented(a:line)
		return a:line
	endif

	if comment#is_wrap()
		" TODO
		return a:line
	else
		return substitute(&cms, '%s$', '', '') . ' ' . a:line
	endif

endfunc

func! comment#uncomment(line)

	if empty(a:line) || !comment#is_commented(a:line)
		return a:line
	endif

	if comment#is_wrap()
		" TODO
		return a:line
	else
		return substitute(a:line, '^' . substitute(escape(&cms, '\'), '%s$', '', '') . ' ', '', '')
	endif
endfunc

func! comment#toggle()
	let line = getline('.')
	if comment#is_commented(line)
		call setline('.', comment#uncomment(line))
	else
		call setline('.', comment#comment(line))
	endif
endfunc

func! comment#init()
	com! -range CommentToggle <line1>,<line2>call comment#toggle()
	com! -range Comment <line1>,<line2>call comment#comment()
	com! -range Uncomment <line1>,<line2>call comment#uncomment()
endfunc
