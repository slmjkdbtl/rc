" wengwengweng

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

		if line ==# '..'
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

endfunc

func! s:get_current()

	let cl = line('.')
	let item = b:listing[cl - 1]

	return item

endfunc

func! s:to_line(ln)

	exec ':' . a:ln

endfunc

func! s:to_item(item)

	for i in range(len(b:listing))

		if b:listing[i] == a:item
			call s:to_line(i + 1)
		endif

	endfor

endfunc

func! s:bind()

	noremap <buffer><silent> <return> :call browser#enter()<cr>
	noremap <buffer><silent> <bs> :call browser#back()<cr>
	noremap <buffer><silent> <tab> :call browser#close()<cr>
	noremap <buffer><silent> <space> :call browser#expand()<cr>
	noremap <buffer><silent> y :call browser#copy()<cr>
	noremap <buffer><silent> r :call browser#refresh()<cr>
	noremap <buffer><silent> j j
	noremap <buffer><silent> k k

endfunc

func! browser#refresh()

	let b:listing = s:get_listing()
	let name = fnamemodify(getcwd(), ':t')

	exec 'file ' . name
	setlocal modifiable
	call s:render()
	setlocal nomodifiable
	setlocal nomodified
	call s:to_line(2)

endfunc

func! browser#back()

	let prev_dir = getcwd()

	lcd ..
	call browser#refresh()
	call s:to_item(prev_dir)

endfunc

func! browser#close()

	if &filetype ==# 'browser'
		silent! bw
	endif

endfunc

func! browser#expand()

	" ...

endfunc

func! browser#copy()

	let item = s:get_current()
	let @* = item

	echo item

endfunc

func! browser#enter()

	let current_dir = getcwd()
	let item = s:get_current()

	if isdirectory(item)

		silent! exec 'lcd ' . item
		call browser#refresh()

	elseif filereadable(item)

		call browser#close()
		silent! exec 'edit ' . item

	endif

endfunc

func! browser#search(char)

	let b:search_char = a:char

	for i in range(len(b:listing))

		let name = fnamemodify(b:listing[i], ':t')[0:0]

		if name == a:char
			exec ':' . (i + 1)
		endif

	endfor

endfunc

func! browser#open()

	let current_buffer = expand('%:p')

	enew

	let b:listing = []

	setfiletype browser
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nobuflisted
	call browser#refresh()
	call s:bind()
	call s:to_item(current_buffer)

endfunc

