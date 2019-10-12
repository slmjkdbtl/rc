" wengwengweng

func! s:get()

	let file = expand(g:bookmark_file)

	if !filereadable(file)
		return []
	endif

	let bookmarks = []

	for p in readfile(file)

		let name = matchstr(p, '\[.*\]')
		let path = matchstr(p, '(.*)')
		let name = name[1:strlen(name) - 2]
		let path = path[1:strlen(path) - 2]

		let bookmarks = bookmarks + [{
			\ 'name': name,
			\ 'path': path,
		\ }]

	endfor

	return bookmarks

endfunc

func! s:write(bookmarks)

	let list = []

	for p in a:bookmarks
		let list = list + [ s:format(p) ]
	endfor

	if writefile(list, expand(g:bookmark_file)) == -1
		return -1
	endif

	return 0

endfunc

func! s:format(proj)
	return '[' . a:proj.name . '](' . a:proj.path . ')'
endfunc

func! s:search(bookmarks, key)

	for p in a:bookmarks
		if match(p.name, '\c' . a:key) != -1
			return p
		endif
	endfor

	return -1

endfunc

func! bookmark#add(name)

	let bookmarks = s:get()

	if exists('a:name') && a:name !=# ''

		let name = a:name

		if (name == expand('%:t'))
			let path = expand('%:p')
		else
			let path = getcwd()
		endif

	else

		let name = fnamemodify(getcwd(), ':p:h:t')
		let path = getcwd()

	endif

	for p in bookmarks
		if p.name == name || p.path == path
			echo 'bookmark already exists'
			return -1
		endif
	endfor

	let proj = {
		\ 'name': name,
		\ 'path': path,
	\ }

	let format = s:format(proj)

	if confirm('> add ' . format . '?', "&yes\n&no") == 1

		if s:write(bookmarks + [ proj ]) != -1

			redraw
			echo format . ' added'

			return 0

		else

			echo 'error adding bookmark'

			return -1

		endif

	endif

endfunc

func! bookmark#remove(key)

	let bookmarks = s:get()

	if empty(bookmarks)

		echo 'no bookmarks found'

		return -1

	endif

	if exists('a:key') && a:key !=# ''

		let proj = s:search(bookmarks, a:key)

		if type(proj) == 0 && proj == -1

			echo 'no bookmark to remove'

			return -1

		endif

	else

		if exists('g:bookmark_current')

			let index = index(bookmarks, g:bookmark_current)

			if index != -1
				let proj = bookmarks[index]
			endif

		endif

		if !exists('proj')

			echo 'no bookmark to remove'

			return -1

		end

	end

	let format = s:format(proj)

	if confirm('> remove ' . format . '?', "&yes\n&no") == 1

		let bookmarks = filter(bookmarks, 'v:val != proj')

		if s:write(bookmarks) != -1

			redraw
			let format = s:format(proj)
			echo format . ' removed'

			return 0

		else

			echo 'error removing bookmark'

			return -1

		endif

	else

		return -1

	endif

endfunc

func! bookmark#list()

	let bookmarks = s:get()

	if empty(bookmarks)

		echo 'no bookmarks found'

		return 0

	endif

	for p in bookmarks
		echo s:format(p)
	endfor

endfunc

func! bookmark#switch(proj)

	if !exists('a:proj.path')
		return -1
	endif

	if (isdirectory(a:proj.path))

		silent! exec 'lcd ' . expand(a:proj.path)
		silent! exec 'edit ' . expand(a:proj.path)
		let g:bookmark_current = a:proj

	elseif (filereadable(a:proj.path))

		silent! exec 'edit ' . expand(a:proj.path)
		let g:bookmark_current = a:proj

	else

		echo 'not found'
		return -1

	end

	return 0

endfunc

func! bookmark#jump(pattern)

	let bookmarks = s:get()

	if empty(bookmarks)
		echo 'no bookmarks found'
		return 0
	endif

	let proj = s:search(bookmarks, a:pattern)

	if type(proj) == 4

		return bookmark#switch(proj)

	else

		redraw
		echo 'bookmark not found'

		return -1

	endif

endfunc

