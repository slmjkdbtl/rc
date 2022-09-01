" quickly comment / uncomment lines

func! comment#init()
	com! -range CommentToggle <line1>,<line2>call comment#toggle()
	com! -range Comment       <line1>,<line2>call comment#comment()
	com! -range Uncomment     <line1>,<line2>call comment#uncomment()
endfunc

func! comment#is_commented()
	let line = getline('.')
	return line =~# '^\(\s\|\t\)*' . substitute(escape(&cms, '\*'), '%s', '.*', '')
endfunc

func! comment#comment()

	let line = getline('.')

	" start writing a comment if on empty line
	if empty(line)
		call setline('.', substitute(&cms, '%s', '  ', ''))
		call cursor('.', match(&cms, '%s') + 2)
		startinsert
		return
	endif

	if comment#is_commented()
		return
	endif

	let indent = matchstr(line, '^\(\s\|\t\)*')
	let content = line[len(indent):]
	let commented = indent . substitute(&cms, '%s', ' ' . content . ' ', '')

	call setline('.', substitute(commented, '\s*$', '', ''))

endfunc

func! comment#uncomment()

	let line = getline('.')

	if empty(line) || !comment#is_commented()
		return
	endif

	let indent = matchstr(line, '^\(\s\|\t\)*')
	let content = matchlist(line, substitute(escape(&cms, '\*'), '%s', '\\s*\\(.*\\)', ''))[1]
	let uncommented = indent . content

	call setline('.', substitute(uncommented, '\s*$', '', ''))

endfunc

func! comment#toggle()
	if comment#is_commented()
		call comment#uncomment()
	else
		call comment#comment()
	endif
endfunc
