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

	:1,$d

	for i in range(len(b:filer_listing))

		let line = b:filer_listing[i]

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

	:$,$d

endfunc

func! filer#back()

	lcd ..
	call filer#refresh()

endfunc

func! filer#toggle()

	" ...

endfunc

func! filer#enter()

	let linepos = line('.')
	let item = b:filer_listing[linepos - 1]

	if isdirectory(item)
		silent! exec 'lcd ' . fnamemodify(item, ':p')
		call filer#refresh()
	elseif filereadable(item)
		silent! exec 'edit ' . fnamemodify(item, ':p')
	endif

endfunc

func! filer#refresh()

	let b:filer_listing = s:get_listing()

	setlocal modifiable
	call s:render()
	setlocal nomodifiable
	setlocal nomodified
	:2
	redraw

endfunc

func! filer#open()

	enew
	setlocal filetype=filer
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal mouse=n
	setlocal nobuflisted
	exec 'source '.fnameescape(s:srcdir . '/syntax/filer.vim')
	call filer#refresh()
	noremap <buffer><silent> <return> :call filer#enter()<cr>
	noremap <buffer><silent> <bs> :call filer#back()<cr>
	noremap <buffer><silent> <tab> :call filer#toggle()<cr>

endfunc

