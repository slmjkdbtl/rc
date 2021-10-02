func! fbrowse#open()

	if &mod
		return
	endif

	let curbuf = expand('%:p')

	noautocmd enew
	setl buftype=nofile
	setl bufhidden=wipe
	setl cursorline
	setl nocursorcolumn
	setl nobuflisted
	setl nolist
	setl nonumber
	setl norelativenumber
	setl nospell
	setl colorcolumn=
	setl foldcolumn=0
	setl matchpairs=
	setl noswapfile
	setl nowrap
	setl nomodifiable
	setl nomodified
	setfiletype fbrowse

	call fbrowse#refresh()
	call s:toitem(curbuf)
	call s:bind()

endfunc

func! fbrowse#active()
	return &filetype == 'fbrowse'
endfunc

func! fbrowse#close()
	if fbrowse#active()
		bwipe
	endif
endfunc

func! fbrowse#toggle()
	if fbrowse#active()
		call fbrowse#close()
	else
		call fbrowse#open()
	endif
endfunc

func! s:update_statline()
	let dir = substitute(getcwd(), $HOME, '~', '')
	let dir = escape(dir, ' ')
	exec 'setl statusline=\ ' . dir
endfunc

func! s:getlist(path)

	let path = escape(a:path, '# ')
	let files = glob(path . '/*', 0, 1)
	let hidden = glob(path . '/.*', 0, 1)
	let hidden = filter(hidden, 'fnamemodify(v:val, ":t") !=# ".."')
	let hidden = filter(hidden, 'fnamemodify(v:val, ":t") !=# "."')
	let files += hidden

	let flist = []
	let dlist = []

	for f in files

		if isdirectory(f)
			let dlist += [ f ]
		elseif filereadable(f)
			let flist += [ f ]
		endif

	endfor

	call sort(flist, {a1, a2 -> fnamemodify(a1, ':e') == fnamemodify(a2, ':e') ? 0 : fnamemodify(a1, ':e') > fnamemodify(a2, ':e') ? 1 : -1})

	let list = []
	let list += [ '..' ]
	let list += dlist
	let list += flist

	return list

endfunc

func! s:render()

	setlocal modifiable
	silent! %delete

	for i in range(len(b:listing))

		let item = b:listing[i]
		let displayline = ''

		if item ==# '..'

			let displayline = '..'

		else

			if isdirectory(item)
				let displayline .= '+ '
			elseif filereadable(item)
				let displayline .= '  '
			endif

			let displayline .= fnamemodify(item, ':t')

		endif

		call setline(i + 1, displayline)

	endfor

	setlocal nomodifiable
	setlocal nomodified

endfunc

func! s:toline(ln)
	call cursor(a:ln, 3)
endfunc

func! fbrowse#refresh(...)

	if &filetype !=# 'fbrowse'
		return
	endif

	let b:listing = s:getlist(getcwd())

	call s:render()
	call s:update_statline()

	if exists('a:1')
		call s:toline(a:1)
	else
		call s:toline(2)
	endif

endfunc

func! s:toitem(item)
	for i in range(len(b:listing))
		if s:eq(b:listing[i], a:item)
			call s:toline(i + 1)
		endif
	endfor
endfunc

func! s:eq(f1, f2)
	return fnamemodify(a:f1, ':p') ==# fnamemodify(a:f2, ':p')
endfunc

func! s:getcur()
	let cl = line('.')
	let item = b:listing[cl - 1]
	return item
endfunc

func! fbrowse#back()
	let prev_dir = getcwd()
	lcd ..
	call fbrowse#refresh()
	call s:toitem(prev_dir)
endfunc

func! fbrowse#enter()

	let item = s:getcur()

	if isdirectory(item)

		silent! exec 'lcd ' . escape(item, '# ')
		call fbrowse#refresh()

	elseif filereadable(item)

		let ext = fnamemodify(item, ':e')

		if index([ 'jpg', 'png', 'pdf', 'ico', 'icns', 'ase', 'gif', 'mp4', 'mkv', 'mov', 'avi', 'mp3', 'wav', 'ogg', ], ext) >= 0
			call system('open ' . escape(item, " '&()"))
		else
			call fbrowse#close()
			exec 'edit ' . item
		endif

	endif

endfunc

func! fbrowse#copypath()
	let item = s:getcur()
	let @* = item
	echo item
endfunc

func! s:bind()
	map <buffer><silent> <return> :call fbrowse#enter()<cr>
	map <buffer><silent> <bs> :call fbrowse#back()<cr>
	map <buffer><silent> y :call fbrowse#copypath()<cr>
	map <buffer><silent> r :call fbrowse#refresh()<cr>
endfunc
