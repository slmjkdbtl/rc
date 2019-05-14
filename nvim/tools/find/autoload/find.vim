" wengwengweng

func! find#find()
	call s:init('find', 'bot')
	call s:poll()
endfunc

func! find#grep()
	call s:init('grep', 'bot')
	call s:poll()
endfunc

func! s:init(mode, dir)

	botright new
	noautocmd enew

	let b:mode = a:mode
	let b:dir = a:dir
	let b:input = ''

	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nocursorcolumn
	setlocal nobuflisted
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
	exec 'setfiletype ' . b:mode
	exec 'setlocal statusline=\ ' . b:mode

endfunc

func! s:close()
	silent redraw
	bwipe
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

func! s:enter()
	" ...
endfunc

func! s:poll()

	let nr = getchar()
	let ch = nr2char(nr)

	while nr != 27

		if nr == "\<bs>"
			call s:del()
		elseif nr == "\<up>"
			call s:up()
		elseif nr == "\<down>"
			call s:down()
		elseif nr == "\<return>"
			call s:enter()
		elseif type(ch) == 1
			call s:input(ch)
		endif

		call s:update()

		let nr = getchar()
		let ch = nr2char(nr)

	endwhile

	call s:close()

endfunc

func! s:update()
	if b:mode == 'grep'
		call s:update_grep(b:input)
	elseif b:mode == 'find'
		call s:update_find(b:input)
	endif
endfunc

func! s:update_find(txt)
	" ...
endfunc

func! s:update_grep(pat)

	if empty(a:pat)
		return
	endif

	setlocal modifiable
	silent! %delete

	if exists('b:match')
		call matchdelete(b:match)
	endif

	let prev_grepprg = &grepprg
	let prev_grepformat = &grepformat
	let &grepprg = g:grep_cmd
	let &grepformat = g:grep_format

	silent! exec 'grep! "' . a:pat . '"'

	let b:grep_results = []

	for d in getqflist()

		let fname = bufname(d.bufnr)

		let entry = {
			\ 'text': fname . ':' . d.lnum . ': ' . d.text,
			\ 'file': fname,
			\ 'line': d.lnum,
			\ 'col': d.col,
			\ }

		if b:dir == 'bot'
			let b:grep_results = [entry] + b:grep_results
		else
			let b:grep_results += [entry]
		endif

	endfor

	let num = len(b:grep_results)

	for i in range(num)
		call setline(i + 1, b:grep_results[i].text)
	endfor

	if num > 16
		resize 16
	else
		exec 'resize ' . num
	endif

	setlocal nomodifiable
	setlocal nomodified
	call cursor(line('$'), 1)
	let b:match = matchadd('GrepKeyword', a:pat)

endfunc

func! s:cursor()

	let ln = line('.')
	let cn = col('.')

	call cursor(ln, 1)

endfunc

func! s:open()

	let item = b:find_view[line('.') - 1]

	if exists('item') && has_key(item, 'file')
		bw
		exec 'edit ' . item.file
		call cursor(item.line, 1)
	endif

endfunc

noremap <silent> <plug>(find_open)
			\ :call <sid>open()<cr>

