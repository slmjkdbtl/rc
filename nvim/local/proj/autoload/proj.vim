" wengwengweng

func! s:get()

	let file = expand(g:proj_file)

	if !filereadable(file)
		return []
	endif

	let projs = []

	for p in readfile(file)

		let name = matchstr(p, '\[.*\]')
		let path = matchstr(p, '(.*)')
		let name = name[1:strlen(name) - 2]
		let path = path[1:strlen(path) - 2]

		let projs = projs + [{
			\ 'name': name,
			\ 'path': path,
		\ }]

	endfor

	return projs

endfunc

func! s:write(projs)

	let list = []

	for p in a:projs
		let list = list + [ s:format(p) ]
	endfor

	if writefile(list, expand(g:proj_file)) == -1
		return -1
	endif

	return 0

endfunc

func! s:format(proj)
	return '[' . a:proj.name . '](' . a:proj.path . ')'
endfunc

func! s:search(projs, key)

	for p in a:projs
		if match(p.name, '\c' . a:key) != -1
			return p
		endif
	endfor

	return -1

endfunc

func! proj#add(name)

	let projs = s:get()

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

	for p in projs
		if p.name == name || p.path == path
			echo 'project already exists'
			return -1
		endif
	endfor

	let proj = {
		\ 'name': name,
		\ 'path': path,
	\ }

	let format = s:format(proj)

	if confirm('> add ' . format . '?', "&yes\n&no") == 1

		if s:write(projs + [ proj ]) != -1

			redraw
			echo format . ' added'

			return 0

		else

			echo 'error adding project'

			return -1

		endif

	endif

endfunc

func! proj#remove(key)

	let projs = s:get()

	if empty(projs)

		echo 'no project found'

		return -1

	endif

	if exists('a:key') && a:key !=# ''

		let proj = s:search(projs, a:key)

		if type(proj) == 0 && proj == -1

			echo 'nothing to remove'

			return -1

		endif

	else

		if exists('g:proj_current')

			let index = index(projs, g:proj_current)

			if index != -1
				let proj = projs[index]
			endif

		endif

		if !exists('proj')

			echo 'no proj to remove'

			return -1

		end

	end

	let format = s:format(proj)

	if confirm('> remove ' . format . '?', "&yes\n&no") == 1

		let projs = filter(projs, 'v:val != proj')

		if s:write(projs) != -1

			redraw
			let format = s:format(proj)
			echo format . ' removed'

			return 0

		else

			echo 'error removing project'

			return -1

		endif

	else

		return -1

	endif

endfunc

func! proj#list()

	let projs = s:get()

	if empty(projs)

		echo 'no project found'

		return 0

	endif

	for p in projs
		echo s:format(p)
	endfor

endfunc

func! proj#switch(proj)

	if !exists('a:proj.path')
		return -1
	endif

	if (isdirectory(a:proj.path))

		silent! exec 'lcd ' . expand(a:proj.path)
		silent! exec 'edit ' . expand(a:proj.path)
		let g:proj_current = a:proj

	elseif (filereadable(a:proj.path))

		silent! exec 'edit ' . expand(a:proj.path)
		let g:proj_current = a:proj

	else

		echo 'not found'
		return -1

	end

	return 0

endfunc

func! proj#jump(pattern)

	let projs = s:get()

	if empty(projs)
		echo 'no projects found'
		return 0
	endif

	let proj = s:search(projs, a:pattern)

	if type(proj) == 4

		return proj#switch(proj)

	else

		redraw
		echo 'project not found'

		return -1

	endif

endfunc

