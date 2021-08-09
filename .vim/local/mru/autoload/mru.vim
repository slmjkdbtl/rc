" wengwengweng

func! s:write(list)

	if writefile(a:list, expand(g:mru_file)) == -1
		return 0
	endif

	return 1

endfunc

func! mru#get()

	let file = expand(g:mru_file)

	if !filereadable(file)
		return []
	endif

	return readfile(file)

endfunc

func! mru#add(path)

	if !filereadable(a:path)
		return
	endif

	let files = mru#get()
	let time = strftime('%x')

	for i in range(len(files))

		if a:path ==# files[i]

			" early return if it's already the first
			if i == 1
				return
			endif

			" remove it to add / move to front
			call remove(files, i)
			break

		endif

	endfor

	" add to front
	call insert(files, a:path, 0)
	let num_files = len(files)

	if num_files > g:mru_limit
		call remove(files, num_files - 1)
	endif

	call s:write(files)

endfunc

func! mru#start()

	augroup MRU

		autocmd!
		autocmd BufRead,BufNewFile,BufWrite *
			\ call mru#add(expand('%:p'))

	augroup END

endfunc

