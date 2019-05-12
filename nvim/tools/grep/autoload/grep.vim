" wengwengweng

func! grep#search(txt)

	let l:opts = ' '

	if &ignorecase == 1
		let l:opts = l:opts . '-i '
	endif

	if &smartcase == 1
		let l:opts = l:opts . '-S '
	endif

	let prev_grepprg = &grepprg
	let prev_grepformat = &grepformat
	let &grepprg = g:grep_cmd
	let &grepformat = g:grep_format

	silent! exec 'grep! ' . l:opts . '"' . a:txt . '"'

	botright new
	enew
	setfiletype grep
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nobuflisted
	setlocal expandtab

	let b:grep_results = {}
	let b:grep_view = []

	for d in getqflist()

		let fname = bufname(d.bufnr)
		let item = {
			\ 'line': d.lnum,
			\ 'col': d.col,
			\ 'text': d.text,
			\ }

		if has_key(b:grep_results, fname)
			let b:grep_results[fname] += [item]
		else
			let b:grep_results[fname] = [item]
		endif

	endfor

	for fname in keys(b:grep_results)

		let entries = b:grep_results[fname]

		let b:grep_view += [{
					\ 'text': '= ' . fname,
					\ 'file': fname,
					\ 'line': 1,
					\ }]

		for e in entries

			let b:grep_view += [{
						\ 'text': string(e.line) . ': ' . e.text,
						\ 'file': fname,
						\ 'line': e.line,
						\ }]

		endfor

		let b:grep_view += [{
					\ 'text': '',
					\ }]

	endfor

	for i in range(len(b:grep_view))
		call append(i, b:grep_view[i].text)
	endfor

	retab

	silent! $delete
	setlocal nomodifiable
	setlocal nomodified
	call cursor(1, 1)

	map <buffer><silent> <return> <Plug>(grep_open)

	let &grepprg = prev_grepprg
	let &grepformat = prev_grepformat

endfunc

func! grep#open()

	let item = b:grep_view[line('.') - 1]

	if exists('item') && has_key(item, 'file')
		bw
		exec 'edit ' . item.file
		call cursor(item.line, 1)
	endif

endfunc

noremap <silent> <Plug>(grep_open)
			\ :call grep#open()<cr>

