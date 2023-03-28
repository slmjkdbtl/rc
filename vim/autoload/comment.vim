" quickly comment / uncomment lines

func! comment#init()
	com! -range CommentToggle <line1>,<line2>call comment#toggle()
	com! -range Comment       <line1>,<line2>call comment#comment()
	com! -range Uncomment     <line1>,<line2>call comment#uncomment()
endfunc

func! comment#is_commented()
	if empty(&cms)
		return 0
	endif
	let line = getline('.')
	return line =~# '^\(\s\|\t\)*' . substitute(escape(&cms, '\*'), '%s', '.*', '')
endfunc

func! s:getindent(line)
	return matchstr(a:line, '^\(\s\|\t\)*')
endfunc

func! s:isempty(line)
	return a:line =~# '^\(\s\|\t\)*$'
endfunc

func! s:trim(line)
	return substitute(a:line, '\s*$', '', '')
endfunc

" TODO: when range use least indent
func! comment#comment()

	if !&modifiable || empty(&cms)
		return
	endif

	let line = getline('.')

	if empty(line) || s:isempty(line) || comment#is_commented()
		return
	endif

	let indent = s:getindent(line)
	let content = line[len(indent):]
	let commented = indent . substitute(&cms, '%s', ' ' . escape(content, '\&') . ' ', '')
	let commented = s:trim(commented)

	if line !=# commented
		call setline('.', commented)
	endif

endfunc

func! comment#uncomment()

	if !&modifiable || empty(&cms)
		return
	endif

	let line = getline('.')

	if empty(line) || s:isempty(line) || !comment#is_commented()
		return
	endif

	let indent = s:getindent(line)
	let content = matchlist(line, substitute(escape(&cms, '\*'), '%s', '\\s*\\(.*\\)', ''))[1]
	let uncommented = indent . content
	let uncommented = s:trim(uncommented)

	if line !=# uncommented
		call setline('.', uncommented)
	endif

endfunc

func! comment#toggle()
	if comment#is_commented()
		call comment#uncomment()
	else
		call comment#comment()
	endif
endfunc
