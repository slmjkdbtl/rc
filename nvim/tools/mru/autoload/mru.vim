" wengwengweng

func! s:get()

	let file = expand(g:mru_file)

	if !filereadable(file)
		return []
	endif

	return readfile(file)

endfunc

func! s:write(list)

	if writefile(a:list, expand(g:mru_file)) == -1
		return 0
	endif

	return 1

endfunc

func! mru#add(file)

	if !filereadable(a:file)
		return
	endif

	let files = add(s:get(), a:file)
	let num_files = len(files)

	if num_files > g:mru_limit
		let files = files[num_files - g:mru_limit:num_files]
	endif

	call s:write(files)

endfunc

func! mru#start()

	augroup MRU

		autocmd!
		autocmd BufRead,BufNewFile *
			\ call mru#add(expand('%:p'))

	augroup END

endfunc

func! mru#show()
	" ...
endfunc

