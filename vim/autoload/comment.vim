" quickly comment / uncomment lines

func! comment#init()
	com! -range CommentToggle <line1>,<line2>call comment#toggle()
	com! -range Comment       <line1>,<line2>call comment#comment()
	com! -range Uncomment     <line1>,<line2>call comment#uncomment()
endfunc

func! comment#is_commented(line)
	return a:line =~# '^\(\s\|\t\)*' . substitute(escape(&cms, '\*'), '%s', '.*', '')
endfunc

func! comment#comment(line)

	if empty(a:line) || comment#is_commented(a:line)
		return a:line
	endif

	let indent = matchstr(a:line, '^\(\s\|\t\)*')
	let content = a:line[len(indent):]
	let commented = indent . substitute(&cms, '%s', ' ' . content . ' ', '')

	return substitute(commented, '\s*$', '', '')

endfunc

func! comment#uncomment(line)

	if empty(a:line) || !comment#is_commented(a:line)
		return a:line
	endif

	let indent = matchstr(a:line, '^\(\s\|\t\)*')
	let content = matchlist(a:line, substitute(escape(&cms, '\*'), '%s', '\\s*\\(.*\\)', ''))[1]
	let uncommented = indent . content

	return substitute(uncommented, '\s*$', '', '')

endfunc

func! comment#write_comment()
	call setline('.', substitute(&cms, '%s', '  ', ''))
	call cursor('.', match(&cms, '%s') + 2)
	startinsert
endfunc

func! comment#toggle()
	let line = getline('.')
	if comment#is_commented(line)
		call setline('.', comment#uncomment(line))
	else
		if empty(line)
			call comment#write_comment()
		else
			call setline('.', comment#comment(line))
		endif
	endif
endfunc
