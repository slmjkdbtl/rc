" wengwengweng

let s:searching = 0

func! s:search_start()

	if s:searching
		return
	endif

	let s:searching = 1
	let s:grepprg = &grepprg
	let &grepprg = g:grep_cmd

	let s:te = &t_te
	let s:ti = &t_ti
	set t_te=
	set t_ti=

endfunc

func! s:search_end()

	if !s:searching
		return
	endif

	let s:searching = 0

	let &t_te = s:te
	let &t_ti = s:ti
	let &grepprg = s:grepprg

endfunc

func! grep#search(txt)

	let l:opts = ' '

	if &ignorecase == 1
		let l:opts = l:opts . '-i '
	endif

	if &smartcase == 1
		let l:opts = l:opts . '-S '
	endif

	call s:search_start()

	silent! exe 'grep! ' . l:opts . '"' . a:txt . '"'

	for d in getqflist()
" 		echo bufname(d.bufnr) ':' d.lnum '   ' d.text
	endfor

	exe 'botright copen'
	call s:search_end()

endfunc

