" wengwengweng

func! s:is_commented(line)
	return a:line =~# '^\s*' . substitute(&commentstring, '%s', '.*', '')
endfunc

func! s:is_commentstring_valid()

	let c = &commentstring
	let l = len(c)

	return c[l - 2:l] !=# '%s'

endfunc

func! comment#on()

	let line = getline('.')

	if empty(line) || s:is_commented(line)
		return
	endif

	if s:is_commentstring_valid()
		return
	endif

	let commented = substitute(&commentstring, '%s', ' ' . escape(line, '&\.'), '')

	call setline('.', commented)

endfunc

func! comment#off()

	let line = getline('.')

	if empty(line) || !s:is_commented(line)
		return
	endif

	if s:is_commentstring_valid()
		return
	endif

	let commented = substitute(line, '^\s*' . substitute(&commentstring, '%s', '', '') . ' ', '', '')

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

noremap <silent> <plug>(comment_toggle)
			\ :call comment#toggle()<cr>

noremap <silent> <plug>(comment_on)
			\ :call comment#on()<cr>

noremap <silent> <plug>(comment_off)
			\ :call comment#off()<cr>

