" wengwengweng

let s:searching = 0

func! s:search_start()

	if s:searching
		return
	endif

	let s:searching = 1
	let s:prev_grepprg = &grepprg
	let s:prev_grepformat = &grepformat
	let &grepprg = g:grep_cmd
	let &grepformat = g:grep_format

endfunc

func! s:search_end()

	if !s:searching
		return
	endif

	let s:searching = 0
	let &grepprg = s:prev_grepprg
	let &grepformat = s:prev_grepformat

endfunc

func! s:get_lines()

	let lines = []

	for l in b:grep_results
		let lines += [ l.file . ':' . l.line . '   ' . l.text ]
	endfor

	return lines

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

	let b:grep_results = []

	for d in getqflist()

		let b:grep_results += [{
					\ 'file': bufname(d.bufnr),
					\ 'line': d.lnum,
					\ 'col': d.col,
					\ 'text': d.text,
					\ }]

	endfor

	call view#update(s:get_lines())
	call view#to(1)

	let @/ = escape(a:txt, "\\/.*'$^~[]")
	call feedkeys(":set hlsearch\<cr>", 'n')

	map <buffer><silent> <return> <Plug>(grep_open)

	call s:search_end()

endfunc

func! grep#open()

	let item = b:grep_results[line('.') - 1]

	if exists('item')
		exec 'bd'
		exec 'edit ' . item.file
		exec ':' . item.line
	endif

endfunc

noremap <silent> <Plug>(grep_open)
			\ :call grep#open()<cr>

