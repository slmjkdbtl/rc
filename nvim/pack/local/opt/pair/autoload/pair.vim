" wengwengweng

func! pair#pair(ch1, ch2)

	let line = getline('.')
	let pos = col('.') - 1

	if a:ch1 ==# "'"
		if line[pos - 1] =~# '\w'
			return a:ch1
		endif
	endif

	if a:ch1 ==# '('
		if line[pos - 1] =~# '\w' && line[pos] =~# '\w'
			return a:ch1
		endif
	endif

	return a:ch1 . a:ch2 . "\<left>"

endfunc

func! pair#wrap(ch1, ch2)
	" ...
endfunc

func! pair#del()

	let line = getline('.')
	let pos = col('.') - 1

	for w in g:pair_wrappers
		if line[pos - 1 : pos] == w[0] . w[1]
			return "\<backspace>\<del>"
		endif
	endfor

	return "\<backspace>"

endfunc

func! pair#bind()

	for p in g:pair_wrappers

		let ech1 = substitute(p[0], "'", "''", 'g')
		let ech2 = substitute(p[1], "'", "''", 'g')

		exec 'inoremap <silent> ' . p[0] . " <c-r>=pair#pair('" . ech1 . "', '" . ech2 . "')<cr>"
		exec 'vnoremap <silent> ' . p[0] . ' <esc>`<i' . p[0] . '<esc>`>a<right>' . p[1] . '<esc>'

	endfor

	inoremap <silent> <backspace> <c-r>=pair#del()<cr>

endfunc

