" file browser
" TODO: bulk rename

func! browse#init()

	com! -nargs=0 Browse       call <sid>open()
	com! -nargs=0 BrowseExit   call <sid>exit()
	com! -nargs=0 BrowseToggle call <sid>toggle()

	aug Browse
		au!
		au BufEnter *
			\ call <sid>onenter()
	aug END

endfunc

func! s:open(dir)

	if !isdirectory(a:dir)
		return
	endif

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

	syn match BrowseParent '^..$' containedin=BrowseItem
	syn match BrowseDirHead '^\(+\|-\)' containedin=BrowseDir
	syn match BrowseMarked '>\s' containedin=BrowseItem
	syn match BrowseDir '^\(+\|-\).*' containedin=BrowseItem contains=BrowseDirHead,BrowseMarked
	syn match BrowseItem '^.*$' contains=BrowseDir,BrowseMarked

	hi def link BrowseItem    Cleared
	hi def link BrowseDir     Function
	hi def link BrowseDirHead Special
	hi def link BrowseParent  PreProc
	hi def link BrowsBrowse   String
	hi def link BrowseMarked  String

	map <buffer><silent> <return> :call <sid>enter()<cr>
	map <buffer><silent> <bs>     :call <sid>back()<cr>
	map <buffer><silent> y        :call <sid>copypath()<cr>
	map <buffer><silent> r        :call <sid>refresh()<cr>
	map <buffer><silent> <m-m>    :call <sid>mkdir()<cr>
	map <buffer><silent> <m-r>    :call <sid>rename()<cr>
	map <buffer><silent> <m-d>    :call <sid>delete()<cr>
	map <buffer><silent> <space>  :call <sid>mark()<cr>

	let b:list = []
	let b:marked = []

	call s:update(a:dir)

endfunc

func! s:active()
	return &ft == 'browse'
endfunc

func! s:onenter()
	let path = expand('%:p')
	if empty(path)
		call s:open(getcwd())
	else
		if isdirectory(path)
			if path[-1:-1] == '/'
				let path = path[0:-2]
			endif
			bw
			exec 'lcd ' . path
			call s:open(path)
		elseif filereadable(path)
			exec 'lcd ' . fnamemodify(path, ':h')
		endif
	endif
endfunc

func! s:exit()
	if s:active()
		bw
	endif
endfunc

func! s:toggle()
	if s:active()
		call s:exit()
	else
		let curbuf = expand('%:p')
		if !isdirectory(curbuf)
			call s:open(fnamemodify(curbuf, ':h'))
			call s:toitem(curbuf)
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

	setl modifiable
	sil! %delete _

	for i in range(len(b:list))

		let item = b:list[i]
		let displayline = ''

		if item ==# '..'

			let displayline = '..'

		else

			if isdirectory(item)
				let displayline .= '+ '
			elseif filereadable(item)
				let displayline .= '  '
			endif

			if s:is_marked(item)
				let displayline .= '> '
			endif

			let displayline .= fnamemodify(item, ':t')

		endif

		call setline(i + 1, displayline)

	endfor

	setl nomodifiable
	setl nomodified

endfunc

func! s:refresh()
	let cur = s:getcur()
	call s:update(getcwd())
	call s:toitem(cur)
endfunc

func! s:update(dir)
	if !s:active()
		return
	endif
	let b:list = s:getlist(a:dir)
	call s:render()
	call s:toitem(b:list[1])
endfunc

func! s:toitem(item)
	if !s:active()
		return
	endif
	for i in range(len(b:list))
		if s:eq(b:list[i], a:item)
			call cursor(i + 1, 3)
		endif
	endfor
endfunc

func! s:eq(f1, f2)
	return fnamemodify(a:f1, ':p') ==# fnamemodify(a:f2, ':p')
endfunc

func! s:getcur()
	let cl = line('.')
	let item = b:list[cl - 1]
	return item
endfunc

func! s:back()
	let curdir = getcwd()
	let todir = fnamemodify(curdir, ':h')
	exec 'sil! edit ' . todir
	call s:toitem(curdir)
endfunc

func! s:enter()

	let item = s:getcur()

	if isdirectory(item)
		exec 'sil! edit ' . escape(item, '# ')
	elseif filereadable(item)

		let ext = fnamemodify(item, ':e')

		if index([ 'jpg', 'png', 'pdf', 'ico', 'icns', 'ase', 'gif', 'mp4', 'mkv', 'mov', 'avi', 'mp3', 'wav', 'ogg', ], ext) >= 0
			call system('open ' . escape(item, " '&()"))
		else
			exec 'sil! edit ' . item
		endif

	endif

endfunc

func! s:copypath()
	let item = s:getcur()
	let @+ = item
	let @" = item
	echo item
endfunc

func! s:mkdir()
	let name = input('mkdir: ')
	call system('mkdir ' . name)
	call s:refresh()
	call s:toitem(name)
endfunc

func! s:rename()
	let item = s:getcur()
	let name = input('rename ' . fnamemodify(item, ':t') . ' to: ')
	if empty(name)
		echo 'name no good'
		return
	endif
	let path = fnamemodify(item, ':h') . '/' . name
	call system('mv ' . item . ' ' . path)
	call s:refresh()
	call s:toitem(path)
endfunc

func! s:delete()
	let path = s:getcur()
	let name = fnamemodify(path, ':t')
	if confirm('delete "' . name . '"?', "&yes\n&no") != 1
		return
	endif
	if empty(g:trashdir)
		call system('rm ' . path)
	else
		if !isdirectory(g:trashdir)
			call mkdir(g:trashdir, 'p')
		endif
		call system('mv ' . path . ' ' . g:trashdir)
	endif
	call s:refresh()
endfunc

func! s:mark()

	if line('.') ==# 1
		return
	endif

	let file = s:getcur()

	if s:is_marked(file)
		call remove(b:marked, index(b:marked, file))
	else
		let b:marked += [ file ]
	endif

	call s:refresh()

endfunc

func! s:is_same(f1, f2)
	return fnamemodify(a:f1, ':p') ==# fnamemodify(a:f2, ':p')
endfunc

func! s:is_marked(f)

	if !exists('b:marked')
		return 0
	endif

	for m in b:marked
		if s:is_same(a:f, m)
			return 1
		endif
	endfor

	return 0

endfunc

func! s:bulk_rename()

	if empty(b:marked)
		return
	endif

	let marked = b:marked

	if confirm('rename selected files?', "&yes\n&no") != 1
		return
	endif

	noa enew
	setl buftype=acwrite
	setl bufhidden=wipe
	setf rename
	file rename

	for i in range(len(marked))
		call setline(i + 1, fnamemodify(marked[i], ':t'))
	endfor

	set nomodified
	call cursor(1, 1)

	aug BrowseBulkRename
		au!
		au BufWriteCmd rename call <sid>bulk_rename_apply()
	aug END

endfunc

func! s:bulk_rename_apply()

	let names = getline(1,'$')
	let files = b:marked

	for i in range(len(names))
		call s:job('mv "' . fnamemodify(files[i], ':t') . '" "' . names[i] . '"', { 'on_exit': function('browser#refresh') })
	endfor

	bw!
	call browser#start()

endfunc
