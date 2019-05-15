" wengwengweng

func! find#start(mode)

	if s:is_active()
		return
	endif

	call s:open()
	call s:init(a:mode)
	call s:poll()

endfunc

func! s:open()

	botright new
	noautocmd enew

	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nocursorcolumn
	setlocal nobuflisted
	setlocal cursorline
	setlocal nolist
	setlocal nonumber
	setlocal norelativenumber
	setlocal nospell
	setlocal colorcolumn=
	setlocal foldcolumn=0
	setlocal matchpairs=
	setlocal noswapfile
	setlocal expandtab
	setlocal nowrap
	resize 0

	redraw

endfunc

func! s:poll()

	while 1

		let nr = getchar()
		let ch = nr2char(nr)

		if nr == 27
			call s:close()
			break
		elseif nr == "\<bs>"
			call s:del()
			call s:update()
		elseif nr == "\<up>"
			call s:up()
		elseif nr == "\<down>"
			call s:down()
		elseif nr == 13
			call s:enter()
		elseif type(ch) == 1
			call s:input(ch)
			call s:update()
		endif

		if !s:is_active()
			break
		endif

		redraw

	endwhile

endfunc

func! s:is_active()
	return &ft == 'find' || &ft == 'grep' || &ft == 'mru'
endfunc

func! s:close()

	if exists('b:match')
		call matchdelete(b:match)
	endif

	if s:is_active()
		bwipe
	endif

endfunc

func! s:del()

	let len = len(b:input)

	if len == 1
		let b:input = ''
	else
		let b:input = b:input[0:len - 2]
	endif

	call s:refresh_cmd()

endfunc

func! s:input(ch)
	let b:input .= a:ch
	call s:refresh_cmd()
endfunc

func! s:refresh_cmd()
	redraw
	echo '> ' . b:input
endfunc

func! s:up()
	call cursor(line('.') - 1, 1)
endfunc

func! s:down()
	call cursor(line('.') + 1, 1)
endfunc

func! s:set_height(n)
	exec 'resize ' . (a:n > g:find_max_height ? g:find_max_height : a:n)
endfunc

func! s:clear()

	setlocal modifiable
	silent! %delete
	setlocal nomodifiable
	setlocal nomodified
	call s:set_height(1)

endfunc

func! s:init(mode)

	let b:mode = a:mode
	let b:input = ''
	exec 'setfiletype ' . b:mode
	exec 'setlocal statusline=\ ' . b:mode
	redraw

	call function('s:init_' . b:mode)()

endfunc

func! s:update()

	call function('s:update_' . b:mode)(b:input)

	if g:find_win_top
		call cursor(1, 1)
	else
		call cursor(line('$'), 1)
	endif

endfunc

func! s:enter()
	call function('s:enter_' . b:mode)()
endfunc

func! s:init_grep()
	" ...
endfunc

func! s:init_find()
	" ...
endfunc

func! s:init_mru()
	let b:mru_files = mru#get()
	call s:update_mru('')
endfunc

func! s:update_find(pat)

	if exists('b:match')
		call matchdelete(b:match)
	endif

	if len(b:input) < g:find_min_input
		call s:clear()
		return
	endif

	let b:find_results = systemlist('fd ' . a:pat)
	let num = len(b:find_results)

	if !g:find_win_top
		let b:find_results = reverse(b:find_results)
	endif

	setlocal modifiable
	silent! %delete

	for i in range(num)
		call setline(i + 1, b:find_results[i])
	endfor

	setlocal nomodifiable
	setlocal nomodified

	call s:set_height(num)

	let b:match = matchadd('FindKeyword', a:pat)

endfunc

func! s:update_grep(pat)

	let b:grep_results = []

	if len(b:input) < g:find_min_input
		call s:clear()
		return
	endif

	if exists('b:match')
		call matchdelete(b:match)
	endif

	let prev_grepprg = &grepprg
	let prev_grepformat = &grepformat
	let &grepprg = g:grep_cmd
	let &grepformat = g:grep_format

	silent! exec 'grep! "' . a:pat . '"'

	let &grepprg = prev_grepprg
	let &grepformat = prev_grepformat

	for d in getqflist()

		let fname = bufname(d.bufnr)

		let entry = {
			\ 'text': fname . ':' . d.lnum . ': ' . d.text,
			\ 'file': fname,
			\ 'line': d.lnum,
			\ 'col': d.col,
			\ }

		if g:find_win_top
			let b:grep_results += [entry]
		else
			let b:grep_results = [entry] + b:grep_results
		endif

	endfor

	setlocal modifiable
	silent! %delete

	let num = len(b:grep_results)

	for i in range(num)
		call setline(i + 1, b:grep_results[i].text)
	endfor

	call s:set_height(num)
	setlocal nomodifiable
	setlocal nomodified

	let b:match = matchadd('GrepKeyword', a:pat)

endfunc

func! s:update_mru(pat)

" 	if exists('b:match')
" 		call matchdelete(b:match)
" 	endif

	let b:mru_results = []

	if empty(a:pat)
		let b:mru_results = b:mru_files
	else

		for f in b:mru_files
			if a:pat =~ f
				if g:find_win_top
					let b:mru_results += [f]
				else
					let b:mru_results = [f] + b:mru_results
				endif
			endif
		endfor

	endif

	let num = len(b:mru_results)

	setlocal modifiable
	silent! %delete

	for i in range(num)
		call setline(i + 1, b:mru_results[i])
	endfor

	setlocal nomodifiable
	setlocal nomodified

	call s:set_height(num)

	let b:match = matchadd('MRUKeyword', a:pat)

endfunc

func! s:enter_find()

	let item = b:find_results[line('.') - 1]

	if exists('item')

		call s:close()
		exec 'edit ' . item

	endif

endfunc

func! s:enter_grep()

	let item = b:grep_results[line('.') - 1]

	if exists('item') && has_key(item, 'file')

		call s:close()
		exec 'edit ' . item.file
		call cursor(item.line, item.col)

	endif

endfunc

func! s:enter_mru()

	let item = b:mru_results[line('.') - 1]

	if exists('item')

		call s:close()
		exec 'edit ' . item

	endif

endfunc

