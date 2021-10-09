func! browse#init()

	com! -nargs=0 Browse call browse#open()
	com! -nargs=0 BrowseExit call browse#exit()
	com! -nargs=0 BrowseToggle call browse#toggle()

	no <silent> <plug>(browse_open) :call browse#open()<cr>
	no <silent> <plug>(browse_exit) :call browse#exit()<cr>
	no <silent> <plug>(browse_enter) :call browse#enter()<cr>
	no <silent> <plug>(browse_back) :call browse#back()<cr>
	no <silent> <plug>(browse_copypath) :call browse#copypath()<cr>
	no <silent> <plug>(browse_refresh) :call browse#refresh(getcwd())<cr>
	no <silent> <plug>(browse_up) k
	no <silent> <plug>(browse_down) j

	aug Browse
		au!
		au BufEnter *
			\ call browse#onenter()
	aug END

endfunc

func! browse#open(dir)

	noa enew
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
	setf browse

	syntax match BrowseParent
				\ '^..$'
				\ contained
				\ containedin=BrowseItem

	syntax match BrowseDirHead
				\ '^\(+\|-\)'
				\ contained
				\ containedin=BrowseDir

	syntax match BrowseMarked
				\ '>\s'
				\ contained
				\ containedin=BrowseItem

	syntax match BrowseDir
				\ '^\(+\|-\).*'
				\ contained
				\ containedin=BrowseItem
				\ contains=BrowseDirHead,BrowseMarked

	syntax match BrowseItem
				\ '^.*$'
				\ contains=BrowseDir,BrowseMarked

	highlight def link BrowseItem
				\ Cleared

	highlight def link BrowseDir
				\ Function

	highlight def link BrowseDirHead
				\ Special

	highlight def link BrowseParent
				\ PreProc

	highlight def link BrowsBrowse
				\ String

	call browse#update(a:dir)
	call s:bind()

endfunc

func! browse#active()
	return &ft == 'browse'
endfunc

func! browse#onenter()
	let path = expand('%:p')
	if empty(path)
		call browse#open(getcwd())
	else
		if isdirectory(path)
			if path[-1:-1] == '/'
				let path = path[0:-2]
			endif
			bw
			exec 'lcd ' . path
			call browse#open(path)
		elseif filereadable(path)
			exec 'lcd ' . fnamemodify(path, ':h')
		endif
	endif
endfunc

func! browse#exit()
	if browse#active()
		bw
	endif
endfunc

func! browse#toggle()
	if browse#active()
		call browse#exit()
	else
		let curbuf = expand('%:p')
		if !isdirectory(curbuf)
			call browse#open(fnamemodify(curbuf, ':h'))
			call browse#toitem(curbuf)
		endif
	endif
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
	silent! %delete _

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

func! browse#update(dir)

	if !browse#active()
		return
	endif

	let b:listing = s:getlist(a:dir)

	call s:render()

" 	if exists('a:1')
" 		call s:toline(a:1)
" 	else
		call s:toline(2)
" 	endif

endfunc

func! browse#toitem(item)
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

func! browse#back()
	let curdir = getcwd()
	let todir = fnamemodify(curdir, ':h')
	exec 'silent! edit ' . todir
	call browse#toitem(curdir)
endfunc

func! browse#enter()

	let item = s:getcur()

	if isdirectory(item)
		exec 'silent! edit ' . escape(item, '# ')
	elseif filereadable(item)

		let ext = fnamemodify(item, ':e')

		if index([ 'jpg', 'png', 'pdf', 'ico', 'icns', 'ase', 'gif', 'mp4', 'mkv', 'mov', 'avi', 'mp3', 'wav', 'ogg', ], ext) >= 0
			call system('open ' . escape(item, " '&()"))
		else
			exec 'silent! edit ' . item
		endif

	endif

endfunc

func! browse#copypath()
	let item = s:getcur()
	let @* = item
	let @" = item
	echo item
endfunc

func! s:bind()
	map <buffer><silent> <return> :call browse#enter()<cr>
	map <buffer><silent> <bs> :call browse#back()<cr>
	map <buffer><silent> y :call browse#copypath()<cr>
	map <buffer><silent> r :call browse#update(getcwd())<cr>
endfunc
