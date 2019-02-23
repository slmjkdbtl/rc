" wengwengweng

func! s:trim(t)
	return substitute(a:t, '\n', '', '')
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

func! s:is_expanded(f)

	if !exists('b:expanded')
		return 0
	endif

	for m in b:expanded
		if s:is_same(a:f, m)
			return 1
		endif
	endfor

	return 0

endfunc

func! browser#get_listing(path)

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

func! s:job(cmd, opt)

	if exists('*jobstart')
		call jobstart(a:cmd, a:opt)
	elseif exists('*job_start')
		call job_start(a:cmd)
	else
		call system(a:cmd)
	endif

endfunc

func! s:render()

	setlocal modifiable
	silent! 1,$d

	for i in range(len(b:listing))

		let item = b:listing[i]
		let displayline = ''

		if item ==# '..'

			let displayline = '..'

		else

			if isdirectory(item)
				if s:is_expanded(item)
					let displayline .= '- '
				else
					let displayline .= '+ '
				endif
			elseif filereadable(item)
				let displayline .= '  '
			endif

			if s:is_marked(item)
				let displayline .= '> '
			endif

			let displayline .= fnamemodify(item, ':t')

		endif

		call append(i, displayline)

	endfor

	silent! $,$d
	setlocal nomodifiable
	setlocal nomodified

endfunc

func! s:get_current()

	let cl = line('.')
	let item = b:listing[cl - 1]

	return item

endfunc

func! s:to_line(ln)

	call cursor(a:ln, 3)

endfunc

func! browser#update_git()

	call jobstart('git rev-parse --show-toplevel', {
				\ 'on_stdout': function('browser#update_git_dir')
				\ })

endfunc

func! browser#update_git_dir(j, d, e)

	if empty(join(a:d, ''))
		return
	endif

	let out = s:trim(a:d[0])

	if isdirectory(out)

		let b:git_dir = out

		call jobstart('git ls-files -m', {
					\ 'on_stdout': function('browser#update_git_modified')
					\ })

	else

		let b:git_dir = ''
		let b:git_modified = []

	endif

endfunc

func! browser#update_git_modified(j, d, e)

	if empty(join(a:d, ''))
		return
	endif

	let b:git_modified = a:d

endfunc

func! s:to_item(item)

	for i in range(len(b:listing))

		if s:is_same(b:listing[i], a:item)
			call s:to_line(i + 1)
		endif

	endfor

endfunc

func! browser#refresh(...)

	if &filetype !=# 'browser'
		return
	endif

	let b:listing = browser#get_listing(getcwd())
	let name = fnamemodify(getcwd(), ':t')

	exec 'file ' . name
	call s:render()
	call browser#update_git()

	if exists('a:1')
		call s:to_line(a:1)
	else
		call s:to_line(2)
	endif

endfunc

func! browser#mark()

	if line('.') ==# 1
		return
	endif

	let file = s:get_current()

	if s:is_marked(file)
		call remove(b:marked, index(b:marked, file))
	else
		let b:marked += [ file ]
	endif

	call browser#refresh(line('.'))
	echo 'marked ' . len(b:marked) . ' items'

endfunc

func! browser#expand()

	if line('.') ==# 1
		return
	endif

	let file = s:get_current()

	if !isdirectory(file)
		return
	endif

	if s:is_expanded(file)
		call remove(b:expanded, index(b:expanded, file))
	else
		let b:expanded += [ file ]
	endif

	call browser#refresh(line('.'))

endfunc

func! browser#back()

	let prev_dir = getcwd()

	lcd ..
	call browser#refresh()
	call s:to_item(prev_dir)

endfunc

func! browser#close()

	if b:solid
		return
	endif

	if &filetype ==# 'browser'

		silent! bd

		if empty(bufname('%'))
			call browser#start()
		endif

	endif

endfunc

func! browser#rename()

	if len(b:marked) > 0
		return browser#bulk_rename()
	endif

	let file = s:get_current()
	let name = fnamemodify(file, ':t')
	let new_name = input('rename ' . name . ' to: ')

	call system('mv ' . name . ' ' . new_name)
	call browser#refresh(line('.'))

endfunc

func! browser#bulk_rename()

	let marked = b:marked
	let n = len(b:marked)

	silent! call browser#drop()

	if confirm('> rename ' . n . ' files?', "&yes\n&no") != 1
		return
	end

	enew

	let b:marked = marked
	setfiletype rename
	setlocal buftype=acwrite
	setlocal bufhidden=wipe
	file rename

	for i in range(n)
		call append(i, fnamemodify(marked[i], ':t'))
	endfor

	call cursor(1, 1)

	augroup BrowserBulkRename

		autocmd!
		autocmd BufWriteCmd rename
					\ call s:bulk_rename_apply()

	augroup END

endfunc

func! s:bulk_rename_apply()

	let names = getline(1,'$')
	let files = b:marked

	for i in range(len(names))
		call s:job('mv ' . fnamemodify(files[i], ':t') . ' ' . names[i], { 'on_exit': function('browser#refresh') })
	endfor

	call browser#start()

endfunc

func! browser#mkdir()

	let name = input('create dir: ')

	call system('mkdir ' . name)
	call browser#refresh()
	call s:to_item(name)

endfunc

func! browser#mkfile()
	exec 'e ' . input('create file: ')
endfunc

func! browser#copy()

	let cwd = getcwd()
	let n = len(b:marked)

	if n == 0
		echo 'no marked files'
		return
	endif

	if confirm('> move ' . n . ' files?', "&yes\n&no") != 1
		silent! call browser#drop()
		return
	end

	let first = b:marked[0]

	for f in b:marked
		call system('cp -nr ' . f . ' ' . cwd)
	endfor

	silent! call browser#drop()
	call browser#refresh()
	call s:to_item(fnamemodify(first, ':t'))
	redraw!
	echo 'copied ' . n . ' items'

endfunc

func! browser#move()

	let cwd = getcwd()
	let n = len(b:marked)

	if n == 0
		echo 'no marked files'
		return
	endif

	if confirm('> move ' . n . ' files?', "&yes\n&no") != 1
		silent! call browser#drop()
		return
	end

	for f in b:marked
		call system('mv ' . f . ' ' . cwd)
	endfor

	let first = b:marked[0]

	silent! call browser#drop()
	call browser#refresh()
	call s:to_item(fnamemodify(first, ':t'))
	redraw!
	echo 'moved ' . n . ' items'

endfunc

func! browser#drop()

	redraw
	echo 'dropped ' . len(b:marked) . ' items'
	let b:marked = []
	call browser#refresh(line('.'))

endfunc

func! browser#delete()

	let path = s:get_current()
	let name = fnamemodify(path, ':t')

	if filereadable(path) || isdirectory(path) && path !=# '..'

		if confirm('> delete ' . name . '?', "&yes\n&no") == 1

			call system('trash ' . path)
			silent! exec 'bw ' . name
			call browser#refresh(line('.'))

		end

	endif

endfunc

func! browser#copy_path()

	let item = s:get_current()
	let @* = item

	echo item

endfunc

func! browser#enter()

	let item = s:get_current()

	if isdirectory(item)

		silent! exec 'lcd ' . escape(item, '# ')
		call browser#refresh()

	elseif filereadable(item)

		let ext = fnamemodify(item, ':e')

		if index([ 'jpg', 'png', 'pdf', 'ico', 'icns', 'ase', 'gif', 'mp4', 'mkv', 'mov', 'avi', 'mp3', 'wav', 'ogg', 'obj', ], ext) >= 0

			call system('open ' . escape(item, ' '))

		else

			call browser#close()
			silent! exec 'edit ' . item

		endif

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

func! browser#solidify()

	setlocal buftype=nowrite
	setlocal bufhidden=
	setlocal buflisted
	let b:solid = 1

endfunc

func! browser#start()

	let current_buffer = expand('%:p')

	enew

	let b:listing = []
	let b:marked = []
	let b:solid = 0
	let b:git_dir = ''
	let b:git_modified = []
	let b:expanded = []

	call browser#update_git()

	setfiletype browser
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nobuflisted
	call browser#refresh()
	call s:to_item(current_buffer)
	call browser#bind()

endfunc

func! browser#bind()

	map <buffer><silent> <return> <Plug>(browser_enter)
	map <buffer><silent> <bs> <Plug>(browser_back)
	map <buffer><silent> l <Plug>(browser_enter)
	map <buffer><silent> h <Plug>(browser_back)
	map <buffer><silent> k <Plug>(browser_up)
	map <buffer><silent> j <Plug>(browser_down)
	map <buffer><silent> <tab> <Plug>(browser_close)
	map <buffer><silent> y <Plug>(browser_copy_path)
	map <buffer><silent> <space> <Plug>(browser_mark)
	map <buffer><silent> e <Plug>(browser_expand)
	map <buffer><silent> r <Plug>(browser_refresh)
	map <buffer><silent> <m-r> <Plug>(browser_rename)
	map <buffer><silent> <m-c> <Plug>(browser_copy)
	map <buffer><silent> <m-x> <Plug>(browser_move)
	map <buffer><silent> <m-d> <Plug>(browser_delete)
	map <buffer><silent> <m-m> <Plug>(browser_mkdir)
	map <buffer><silent> <m-n> <Plug>(browser_mkfile)
	map <buffer><silent> <esc> <Plug>(browser_drop)
	map <buffer><silent> <m-s> <Plug>(browser_solidify)

endfunc

noremap <silent> <Plug>(browser_enter)
			\ :call browser#enter()<cr>

noremap <silent> <Plug>(browser_back)
			\ :call browser#back()<cr>

noremap <silent> <Plug>(browser_close)
			\ :call browser#close()<cr>

noremap <silent> <Plug>(browser_copy_path)
			\ :call browser#copy_path()<cr>

noremap <silent> <Plug>(browser_refresh)
			\ :call browser#refresh(line('.'))<cr>

noremap <silent> <Plug>(browser_mark)
			\ :call browser#mark()<cr>

noremap <silent> <Plug>(browser_expand)
			\ :call browser#expand()<cr>

noremap <silent> <Plug>(browser_delete)
			\ :call browser#delete()<cr>

noremap <silent> <Plug>(browser_rename)
			\ :call browser#rename()<cr>

noremap <silent> <Plug>(browser_copy)
			\ :call browser#copy()<cr>

noremap <silent> <Plug>(browser_move)
			\ :call browser#move()<cr>

noremap <silent> <Plug>(browser_drop)
			\ :call browser#drop()<cr>

noremap <silent> <Plug>(browser_mkdir)
			\ :call browser#mkdir()<cr>

noremap <silent> <Plug>(browser_mkfile)
			\ :call browser#mkfile()<cr>

noremap <silent> <Plug>(browser_solidify)
			\ :call browser#solidify()<cr>

noremap <silent> <Plug>(browser_up)
			\ k

noremap <silent> <Plug>(browser_down)
			\ j

