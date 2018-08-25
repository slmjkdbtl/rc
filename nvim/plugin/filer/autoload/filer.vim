" wengwengweng

let s:srcdir = expand('<sfile>:h:h:p')

func! s:get_files()

	let files = glob(getcwd() . '/*', 0, 1)

	return files

endfunc

func! s:get_listing()

	let flist = []
	let dlist = []

	for f in s:get_files()

		if isdirectory(f)
			let dlist += [ f ]
		elseif filereadable(f)
			let flist += [ f ]
		endif

	endfor

	let list = []
	let list += [ '..' ]
	let list += dlist
	let list += flist

	return list

endfunc

func! s:render()

	silent! 1,$d

	for i in range(len(b:listing))

		let line = b:listing[i]

		if line == '..'
			let displayline = '..'
		elseif isdirectory(line)
			let displayline = '+ ' . fnamemodify(line, ':t')
		elseif filereadable(line)
			let displayline = '  ' . fnamemodify(line, ':t')
		endif

		if exists('displayline')
			call append(i, displayline)
		endif

	endfor

	silent! $,$d
	redraw!

endfunc

func! filer#back()

	lcd ..
	call filer#refresh()

endfunc

func! filer#toggle()

	" ...

endfunc

func! filer#expand()

	" ...

endfunc

func! filer#copy()

	let linepos = line('.')
	let item = b:listing[linepos - 1]

" 	let "* = item

endfunc

func! filer#enter()

	let linepos = line('.')
	let item = b:listing[linepos - 1]

	if isdirectory(item)

		silent! exec 'lcd ' . fnamemodify(item, ':p')
		call filer#refresh()

	elseif filereadable(item)

		silent! exec 'edit ' . fnamemodify(item, ':p')

	endif

endfunc

func! filer#search(char)

	let b:search_char = a:char

	for i in range(len(b:listing))

		let name = fnamemodify(b:listing[i], ':t')[0:0]

		if name == a:char
			exec ':' . (i + 1)
		endif

	endfor

endfunc

func! filer#refresh()

	let b:listing = s:get_listing()

	setlocal modifiable
	call s:render()
	setlocal nomodifiable
	setlocal nomodified
	:2

endfunc

func! filer#open()

	enew
	setlocal filetype=filer
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nobuflisted
	exec 'source '.fnameescape(s:srcdir . '/syntax/filer.vim')
	call filer#refresh()
	call filer#bind()

endfunc

func! filer#bind()

" 	let keys = split('qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890', '.\zs')

" 	for k in keys
" 		exec 'noremap <silent> ' . k . ' :call filer#search("' . k . '")<cr>'
" 	endfor

	noremap <buffer><silent> <return> :call filer#enter()<cr>
	noremap <buffer><silent> <bs> :call filer#back()<cr>
	noremap <buffer><silent> <tab> :call filer#toggle()<cr>
	noremap <buffer><silent> <space> :call filer#expand()<cr>
	noremap <buffer><silent> y :call filer#copy()<cr>
	noremap <buffer><silent> j j
	noremap <buffer><silent> k k

endfunc

