" file browser
" TODO: bulk rename

let g:filetree_open_ext = get(g:, 'filetree_open_ext', [ 'jpg', 'png', 'pdf', 'ico', 'icns', 'ase', 'gif', 'mp4', 'mkv', 'mov', 'avi', 'mp3', 'wav', 'ogg', 'flac', 'app' ])

func! filetree#init()

	com! -nargs=0 FileTree       call <sid>open()
	com! -nargs=0 FileTreeExit   call <sid>exit()
	com! -nargs=0 FileTreeToggle call <sid>toggle()

	aug FileTree
		au!
		au BufEnter *
			\ call <sid>onenter()
	aug END

endfunc

func! s:open()
	call s:opendir(getcwd())
endfunc

func! s:opendir(dir)

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
	exec 'set titlestring=' . fnameescape(fnamemodify(a:dir, ':~'))
	setf filetree

	syn match FileTreeParent '^..$' containedin=FileTreeItem
	syn match FileTreeDirHead '^\(+\|-\)' containedin=FileTreeDir
	syn match FileTreeMarked '>\s' containedin=FileTreeItem
	syn match FileTreeDir '^\(+\|-\).*' containedin=FileTreeItem contains=FileTreeDirHead,FileTreeMarked
	syn match FileTreeItem '^.*$' contains=FileTreeDir,FileTreeMarked

	hi def link FileTreeItem    Cleared
	hi def link FileTreeDir     Function
	hi def link FileTreeDirHead Special
	hi def link FileTreeParent  PreProc
	hi def link FileTreeMarked  String

	map <buffer><silent> <return> :call <sid>enter()<cr>
	map <buffer><silent> <bs>     :call <sid>back()<cr>
	map <buffer><silent> y        :call <sid>copypath()<cr>
	map <buffer><silent> <m-c>    :call <sid>copy()<cr>
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
	return &ft == 'filetree'
endfunc

func! s:onenter()
	let path = expand('%:p')
	if empty(path)
		" TODO: this disables :h
		call s:opendir(getcwd())
	else
		if isdirectory(path)
			if path[-1:-1] == '/'
				let path = path[0:-2]
			endif
			bw
			exec 'lcd ' . path
			call s:opendir(path)
		elseif filereadable(path)
			exec 'lcd ' . fnamemodify(path, ':h')
		endif
	endif
endfunc

func! s:exit()
	if s:active()
		set titlestring=
		bw
	endif
endfunc

func! s:toggle()
	if s:active()
		call s:exit()
	else
		let curbuf = expand('%:p')
		if !isdirectory(curbuf)
			call s:opendir(fnamemodify(curbuf, ':h'))
			call s:toitem(curbuf)
		endif
	endif
endfunc

" TODO: file names with ~ not showing
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
	if len(b:list) > 1
		call s:toitem(b:list[1])
	endif
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
		if index(g:filetree_open_ext, ext) >= 0
			call system('open ' . escape(item, " '&()"))
		else
			set titlestring=
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

func! s:copy()
	" TODO
endfunc

func! s:mkdir()
	let name = input('mkdir: ')
	call system('mkdir ' . name)
	call s:refresh()
	call s:toitem(name)
endfunc

func! s:rename()

	if len(b:marked) > 0
		if confirm('rename selected files?', "&yes\n&no") == 1
			call s:bulk_rename()
		endif
		return
	endif

	let item = s:getcur()
	let name = input('rename ' . fnamemodify(item, ':t') . ' to: ')

	if empty(name)
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
		" TODO: edit all file names in buffer like oil.nvim
		return
	endif

	let marked = b:marked

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

	aug FileTreeBulkRename
		au!
		au BufWriteCmd rename call <sid>bulk_rename_apply()
	aug END

endfunc

func! s:bulk_rename_apply()

	let names = getline(1, '$')
	let files = b:marked

	for i in range(len(names))
		call s:job('mv "' . fnamemodify(files[i], ':t') . '" "' . names[i] . '"', { 'on_exit': function('filetree#refresh') })
	endfor

	bw!
	call filetree#start()

endfunc
