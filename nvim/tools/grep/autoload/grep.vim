" wengwengweng

let s:searching = 0

func! s:search_start()

	if s:searching
		return
	endif

	let s:searching = 1
	let s:grepprg = &grepprg
	let &grepprg = g:grep_cmd

endfunc

func! s:search_end()

	if !s:searching
		return
	endif

	let s:searching = 0
	let &grepprg = s:grepprg

endfunc

func! grep#search(txt)

	botright new
	call view#new()

	let l:opts = ' '

	if &ignorecase == 1
		let l:opts = l:opts . '-i '
	endif

	if &smartcase == 1
		let l:opts = l:opts . '-S '
	endif

	call s:search_start()

	silent! exec 'grep! ' . l:opts . '"' . a:txt . '"'

	let list = []

	for d in getqflist()
		let list += [ bufname(d.bufnr) . ':' . d.lnum . '  ' . d.text ]
	endfor

	call view#update(list)
	call view#to(1)

	let @/ = a:txt
	set hlsearch

" 	exe 'botright copen'
	call s:search_end()

endfunc

