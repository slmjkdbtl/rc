" wengwengweng

func! s:get_files()

	let files = glob(getcwd() . '/*', 0, 1)
	let hidden = glob(getcwd() . '/.*', 0, 1)
	let hidden = filter(hidden, 'fnamemodify(v:val, ":t") !=# ".."')
	let hidden = filter(hidden, 'fnamemodify(v:val, ":t") !=# "."')

	return hidden + files

endfunc

func! s:is_same(f1, f2)

	return fnamemodify(a:f1, ':p') ==# fnamemodify(a:f2, ':p')

endfunc

func! s:is_marked(f)

	for m in b:marked
		if s:is_same(a:f, m)
			return 1
		endif
	endfor

	return 0

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

			if s:is_marked(item)
				let displayline .= '> '
			endif

			let displayline .= fnamemodify(item, ':t')

		endif

		call append(i, displayline)

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

func! s:get_git_dir()

	return substitute(system('git rev-parse --show-toplevel'), "\n", '', '')

endfunc

func! s:get_git_modified()

	if !isdirectory(b:git_dir)
		return []
	endif

	return split(system('git ls-files -m'), "\n")

endfunc

func! s:to_item(item)

	for i in range(len(b:listing))

		if s:is_same(b:listing[i], a:item)
			call s:to_line(i + 1)
		endif

	endfor

endfunc

func! s:bind()

	map <buffer><silent> <return> <Plug>(browser_enter)
	map <buffer><silent> <bs> <Plug>(browser_back)
	map <buffer><silent> <tab> <Plug>(browser_close)
	map <buffer><silent> y <Plug>(browser_copy_path)
	map <buffer><silent> <space> <Plug>(browser_mark)
	map <buffer><silent> r <Plug>(browser_refresh)
	map <buffer><silent> <m-r> <Plug>(browser_rename)
	map <buffer><silent> <m-c> <Plug>(browser_copy)
	map <buffer><silent> <m-p> <Plug>(browser_paste)
	map <buffer><silent> <esc> <Plug>(browser_drop)
	map <buffer><silent> <m-m> <Plug>(browser_mkdir)
	map <buffer><silent> k <Plug>(browser_up)
	map <buffer><silent> j <Plug>(browser_down)

endfunc

func! browser#refresh(...)

	let b:listing = s:get_listing()
	let name = fnamemodify(getcwd(), ':t')

	exec 'file ' . name
	setlocal modifiable
	call s:render()
	setlocal nomodifiable
	setlocal nomodified

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

endfunc

func! browser#back()

	let prev_dir = getcwd()

	lcd ..
	call browser#refresh()
	call s:to_item(prev_dir)

endfunc

func! browser#close()

	if &filetype ==# 'browser'

		silent! bd

		if empty(bufname('%'))
			call browser#open()
		endif

	endif

endfunc

func! browser#rename()

	let file = s:get_current()
	let name = fnamemodify(file, ':t')
	let new_name = input('rename ' . name . ' to: ')

	call system('mv ' . name . ' ' . new_name)
	call browser#refresh(line('.'))

endfunc

func! browser#mkdir()

	let name = input('create dir: ')

	call system('mkdir ' . name)
	call browser#refresh(line('.'))

endfunc

func! browser#paste()

	let cwd = getcwd()

endfunc

func! browser#drop()

	echo 'dropped ' . len(b:marked) . ' items'
	let b:marked = []
	call browser#refresh(line('.'))

endfunc

func! browser#delete()

	let path = s:get_current()
	let name = fnamemodify(path, ':t')

	if filereadable(path) || isdirectory(path) && path !=# '..'

		if confirm('> delete ' . name . '?', "&yes\n&no") == 1

			call system('rm -rf ' . path)
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
	let b:marked = []

" 	let git_dir = s:get_git_dir()

" 	if isdirectory(git_dir)

" 		let b:git_dir = git_dir
" 		let b:git_modified = s:get_git_modified()

" 	endif

	setfiletype browser
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nobuflisted
	call browser#refresh()
	call s:to_item(current_buffer)
	call s:bind()

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

noremap <silent> <Plug>(browser_rename)
			\ :call browser#rename()<cr>

noremap <silent> <Plug>(browser_copy)
			\ :call browser#copy()<cr>

noremap <silent> <Plug>(browser_paste)
			\ :call browser#paste()<cr>

noremap <silent> <Plug>(browser_drop)
			\ :call browser#drop()<cr>

noremap <silent> <Plug>(browser_mkdir)
			\ :call browser#mkdir()<cr>

noremap <silent> <Plug>(browser_up)
			\ k

noremap <silent> <Plug>(browser_down)
			\ j

