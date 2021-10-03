func! browse#init()

	command! -nargs=0 Browse
				\ call browse#open()
	command! -nargs=0 BrowseExit
				\ call browse#exit()
	command! -nargs=0 BrowseToggle
				\ call browse#toggle()

	noremap <silent> <plug>(browse_open)
				\ :call browse#open()<cr>
	noremap <silent> <plug>(browse_exit)
				\ :call browse#exit()<cr>
	noremap <silent> <plug>(browse_enter)
				\ :call browse#enter()<cr>
	noremap <silent> <plug>(browse_back)
				\ :call browse#back()<cr>
	noremap <silent> <plug>(browse_copypath)
				\ :call browse#copypath()<cr>
	noremap <silent> <plug>(browse_refresh)
				\ :call browse#refresh(line('.'))<cr>
	noremap <silent> <plug>(browse_up)
				\ k
	noremap <silent> <plug>(browse_down)
				\ j

	au BufEnter *
		\ call browse#onenter()

endfunc

func! browse#open()

	let curbuf = expand('%:p')

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

	call browse#refresh()
	call s:toitem(curbuf)
	call s:bind()

endfunc

func! browse#active()
	return &ft == 'browse'
endfunc

" TODO: not working when closing the last listed buffer, it's still in buflist for some reason
func! browse#onenter()
	let name = expand('%:p')
	if empty(name)
		if len(getbufinfo({ 'buflisted': 1 })) == 1
			call browse#open()
		endif
	else
		if isdirectory(name)
			exec 'lcd ' . name
			bwipe
			call browse#open()
		elseif filereadable(name)
			exec 'lcd ' . expand('%:p:h')
		endif
	endif
endfunc

func! browse#exit()
	if browse#active()
		bwipe
	endif
endfunc

func! browse#toggle()
	if browse#active()
		call browse#exit()
	else
		call browse#open()
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

func! browse#refresh(...)

	if !browse#active()
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

func! browse#back()
	let prev_dir = getcwd()
	lcd ..
	call browse#refresh()
	call s:toitem(prev_dir)
endfunc

func! browse#enter()

	let item = s:getcur()

	if isdirectory(item)

		silent! exec 'lcd ' . escape(item, '# ')
		call browse#refresh()

	elseif filereadable(item)

		let ext = fnamemodify(item, ':e')

		if index([ 'jpg', 'png', 'pdf', 'ico', 'icns', 'ase', 'gif', 'mp4', 'mkv', 'mov', 'avi', 'mp3', 'wav', 'ogg', ], ext) >= 0
			call system('open ' . escape(item, " '&()"))
		else
			call browse#exit()
			exec 'edit ' . item
		endif

	endif

endfunc

func! browse#copypath()
	let item = s:getcur()
	let @* = item
	echo item
endfunc

func! s:bind()
	map <buffer><silent> <return> :call browse#enter()<cr>
	map <buffer><silent> <bs> :call browse#back()<cr>
	map <buffer><silent> y :call browse#copypath()<cr>
endfunc
