" wengwengweng

func! s:get()

	let l:file = expand(g:projekt_file)

	if !filereadable(l:file)
		return []
	endif

	let l:projekts = []

	for l:p in readfile(l:file)

		let l:sign = l:p[0:0]
		let l:name = matchstr(l:p, '\[.*\]')
		let l:path = matchstr(l:p, '(.*)')
		let l:name = l:name[1:strlen(l:name) - 2]
		let l:path = l:path[1:strlen(l:path) - 2]

		let l:projekts = l:projekts + [{
			\ 'sign': sign,
			\ 'name': name,
			\ 'path': path,
		\ }]

	endfor

	return l:projekts

endfunc

func! s:write(projekts)

	let l:list = []

	for l:p in a:projekts
		let l:list = l:list + [ s:format(l:p) ]
	endfor

	if writefile(l:list, expand(g:projekt_file)) == -1
		return -1
	endif

	return 0

endfunc

func! s:format(proj)

	return a:proj.sign . ' [' . a:proj.name . '](' . a:proj.path . ')'

endfunc!

func! s:search(projekts, key)

	for l:p in a:projekts
		if match(l:p.name, '\c' . a:key) != -1
			return l:p
		endif
	endfor

	return {}

endfunc

func! s:search_starred(projekts)

	for l:p in a:projekts
		if l:p.sign == '*'
			return l:p
		endif
	endfor

	return {}

endfunc

func! projekt#add(name)

	let l:projekts = s:get()

	if exists('a:name') && a:name != ''

		let l:name = a:name

		if (l:name == expand('%:t'))
			let l:path = expand('%:p')
		else
			let l:path = getcwd()
		endif

	else

		let l:name = fnamemodify(getcwd(), ":p:h:t")
		let l:path = getcwd()

	endif

	for l:p in l:projekts
		if l:p.name == l:name || l:p.path == l:path
			echo 'projekt already exists'
			return -1
		endif
	endfor

	let l:proj = {
		\ 'sign': '+',
		\ 'name': l:name,
		\ 'path': l:path,
	\ }

	let l:format = s:format(l:proj)

	if confirm('> add ' . l:format . '?', "&yes\n&no") == 1

		if s:write(l:projekts + [ l:proj ]) != -1

			redraw
			echo l:format . ' added'

			return 0

		else

			echo 'error adding projekt'

			return -1

		endif

	endif

endfunc

func! projekt#remove(key)

	let l:projekts = s:get()

	if empty(l:projekts)

		echo 'no projekts found'

		return -1

	endif

	if exists('a:name') && a:name != ''

		for l:p in l:projekts

			if match(l:p.name, '\c' . a:key) != -1

				let l:proj = l:p

				break

			endif

		endfor

	else

		if exists('g:projekt_current')

			let l:index = index(l:projekts, g:projekt_current)

			if l:index != -1
				let l:proj = l:projekts[l:index]
			endif

		endif

	end

	if !exists('l:proj')

		echo 'no projekt to star'

		return -1

	endif

	let l:format = s:format(l:proj)

	if confirm('> remove ' . l:format . '?', "&yes\n&no") == 1

		let l:projekts = filter(l:projekts, 'v:val != l:proj')

		if s:write(l:projekts) != -1

			redraw
			let l:format = s:format(l:proj)
			echo l:format . ' removed'

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

	let l:projekts = s:get()

	if empty(l:projekts)

		echo 'no projekts found'

		return -1

	endif

	if exists('a:name') && a:name != ''

		for l:p in l:projekts

			if match(l:p.name, '\c' . a:key) != -1

				let l:proj = l:p

				break

			endif

		endfor

	else

		if exists('g:projekt_current')

			let l:index = index(l:projekts, g:projekt_current)

			if l:index != -1
				let l:proj = l:projekts[l:index]
			endif

		endif

	end

	if !exists('l:proj')

		echo 'no projekt to star'

		return -1

	endif

	let l:format = s:format(l:proj)

	if confirm('> star ' . l:format . '?', "&yes\n&no") == 1

		for l:p in l:projekts
			let l:p.sign = '+'
		endfor

		let l:proj.sign = '*'

		if s:write(l:projekts) != -1

			redraw
			let l:format = s:format(l:proj)
			echo l:format . ' starred'

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

	let l:projekts = s:get()

	if empty(l:projekts)

		echo 'no projekts found'

		return 0

	endif

	for l:p in l:projekts
		echo s:format(l:p)
	endfor

endfunc

func! projekt#switch(proj)

	if !exists('a:proj.path')
		return -1
	endif

	if (isdirectory(a:proj.path))

		silent! exec 'lcd ' . expand(a:proj.path)
		silent! exec g:projekt_switch_action
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

	let l:projekts = s:get()

	if empty(l:projekts)

		echo 'no projekts found'

		return 0

	endif

	if exists('a:pattern') && a:pattern != ''

		let l:proj = s:search(l:projekts, a:pattern)

	else

		let l:proj = s:search_starred(l:projekts)

		if empty(l:proj)
			let l:proj = l:projekts[0]
		endif

	endif

	if !empty(l:proj)

		return projekt#switch(l:proj)

	else

		echo "projekt not found"

		return -1

	endif

endfunc
