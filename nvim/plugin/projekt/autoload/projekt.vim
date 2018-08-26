" wengwengweng

func! s:get()

	let file = expand(g:projekt_file)

	if !filereadable(file)
		return []
	endif

	let projekts = []

	for p in readfile(file)

		let sign = p[0:0]
		let name = matchstr(p, '\[.*\]')
		let path = matchstr(p, '(.*)')
		let name = name[1:strlen(name) - 2]
		let path = path[1:strlen(path) - 2]

		let projekts = projekts + [{
			\ 'sign': sign,
			\ 'name': name,
			\ 'path': path,
		\ }]

	endfor

	return projekts

endfunc

func! s:write(projekts)

	let list = []

	for p in a:projekts
		let list = list + [ s:format(p) ]
	endfor

	if writefile(list, expand(g:projekt_file)) == -1
		return -1
	endif

	return 0

endfunc

func! s:format(proj)

	return a:proj.sign . ' [' . a:proj.name . '](' . a:proj.path . ')'

endfunc

func! s:search(projekts, key)

	for p in a:projekts
		if match(p.name, '\c' . a:key) != -1
			return p
		endif
	endfor

	return -1

endfunc

func! s:search_starred(projekts)

	for p in a:projekts
		if p.sign ==# '*'
			return p
		endif
	endfor

	return -1

endfunc

func! projekt#add(name)

	let projekts = s:get()

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

	for p in projekts
		if p.name == name || p.path == path
			echo 'projekt already exists'
			return -1
		endif
	endfor

	let proj = {
		\ 'sign': '+',
		\ 'name': name,
		\ 'path': path,
	\ }

	let format = s:format(proj)

	if confirm('> add ' . format . '?', "&yes\n&no") == 1

		if s:write(projekts + [ proj ]) != -1

			redraw
			echo format . ' added'

			return 0

		else

			echo 'error adding projekt'

			return -1

		endif

	endif

endfunc

func! projekt#remove(key)

	let projekts = s:get()

	if empty(projekts)

		echo 'no projekts found'

		return -1

	endif

	if exists('a:key') && a:key !=# ''

		let proj = s:search(projekts, a:key)

		if type(proj) == 0 && proj == -1

			echo 'no projekt to remove'

			return -1

		endif

	else

		if exists('g:projekt_current')

			let index = index(projekts, g:projekt_current)

			if index != -1
				let proj = projekts[index]
			endif

		endif

		if !exists('proj')

			echo 'no projekt to remove'

			return -1

		end

	end

	let format = s:format(proj)

	if confirm('> remove ' . format . '?', "&yes\n&no") == 1

		let projekts = filter(projekts, 'v:val != proj')

		if s:write(projekts) != -1

			redraw
			let format = s:format(proj)
			echo format . ' removed'

			return 0

		else

			echo 'error removing projekt'

			return -1

		endif

	else

		return -1

	endif

endfunc

func! projekt#star(key)

	let projekts = s:get()

	if empty(projekts)

		echo 'no projekts found'

		return -1

	endif

	if exists('a:key') && a:key !=# ''

		let proj = s:search(projekts, a:key)

		if type(proj) == 0 && proj == -1

			echo 'no projekt to star'

			return -1

		endif

	else

		if exists('g:projekt_current')

			let index = index(projekts, g:projekt_current)

			if index != -1
				let proj = projekts[index]
			endif

		endif

		if !exists('proj')

			echo 'no projekt to star'

			return -1

		end

	end

	let format = s:format(proj)

	if confirm('> star ' . format . '?', "&yes\n&no") == 1

		for p in projekts
			let p.sign = '+'
		endfor

		let proj.sign = '*'

		if s:write(projekts) != -1

			redraw
			let format = s:format(proj)
			echo format . ' starred'

			return 0

		else

			echo 'error starring projekt'

			return -1

		endif

	else

		return -1

	endif

endfunc

func! projekt#list()

	let projekts = s:get()

	if empty(projekts)

		echo 'no projekts found'

		return 0

	endif

	for p in projekts
		echo s:format(p)
	endfor

endfunc

func! projekt#switch(proj)

	if !exists('a:proj.path')
		return -1
	endif

	if (isdirectory(a:proj.path))

		silent! exec 'lcd ' . expand(a:proj.path)
		silent! exec 'edit ' . expand(a:proj.path)
		redraw
		echo s:format(a:proj)
		let g:projekt_current = a:proj

	elseif (filereadable(a:proj.path))

		silent! exec 'e ' . expand(a:proj.path)
		let g:projekt_current = a:proj

	else

		echo 'not found'
		return -1

	end

	return 0

endfunc

func! projekt#jump(pattern)

	let projekts = s:get()

	if empty(projekts)

		echo 'no projekts found'

		return 0

	endif

	if a:pattern ==# '' || !exists('a:pattern')

		let proj = s:search_starred(projekts)

		if type(proj) == 0 && proj == -1
			let proj = projekts[0]
		endif

	elseif a:pattern ==# '*'

		let proj = s:search_starred(projekts)

	else

		let proj = s:search(projekts, a:pattern)

	endif

	if type(proj) == 4

		return projekt#switch(proj)

	else

		redraw
		echo 'projekt not found'

		return -1

	endif

endfunc
