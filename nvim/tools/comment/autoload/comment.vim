" wengwengweng

func! s:is_commented(line)
	return a:line =~ substitute(&commentstring, '%s', '.*', '')
endfunc

func! s:validate(line)

	if empty(a:line)
		return 0
	endif

	let c = &commentstring
	let l = len(c)

	if c[l - 2:l] !=# '%s'
		echo "doesn't support wrapped commentstring yet"
		return 0
	endif

	return 1

endfunc

func! comment#on()

	let line = getline('.')

	if s:is_commented(line) || !s:validate(line)
		return
	endif

	let commented = substitute(&commentstring, '%s', ' ' . escape(line, '&\.'), '')

	call setline('.', commented)

endfunc

func! comment#off()

	let line = getline('.')

	if !s:is_commented(line) || !s:validate(line)
		return
	endif

	let commented = substitute(line, substitute(&commentstring, '%s', '', '') . ' ', '', '')

	call setline('.', commented)

endfunc

func! comment#toggle()

	let line = getline('.')

	if s:is_commented(line)
		call comment#off()
	else
		call comment#on()
	endif

endfunc

noremap <silent> <Plug>(comment_toggle)
			\ :call comment#toggle()<cr>

noremap <silent> <Plug>(comment_on)
			\ :call comment#on()<cr>

noremap <silent> <Plug>(comment_off)
			\ :call comment#off()<cr>

