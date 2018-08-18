" wengwengweng

func! pair#pair(ch1, ch2)

	let l:line = getline('.')
	let l:pos = col('.') - 1

	if a:ch1 == "'"
		if l:line[l:pos - 1] =~ '\w'
			return a:ch1
		endif
	endif

	if a:ch1 == '('
		if l:line[l:pos - 1] =~ '\w' && l:line[l:pos] =~ '\w'
			return a:ch1
		endif
	endif

	return a:ch1 . a:ch2 . "\<left>"

endfunc

func! pair#wrap(ch1, ch2)
	" ...
endfunc

func! pair#del()

	let l:line = getline('.')
	let l:pos = col('.') - 1

	for l:w in g:pair_wrappers
		if l:line[l:pos - 1 : l:pos] == l:w[0] . l:w[1]
			return "\<backspace>\<del>"
		endif
	endfor

	return "\<backspace>"

endfunc

func! pair#bind()

	for l:p in g:pair_wrappers

		let l:ech1 = substitute(l:p[0], "'", "''", 'g')
		let l:ech2 = substitute(l:p[1], "'", "''", 'g')

		exec 'inoremap <silent> ' . p[0] . " <c-r>=pair#pair('" . l:ech1 . "', '" . l:ech2 . "')<cr>"
		exec 'vnoremap <silent> ' . p[0] . ' <esc>`<i' . p[0] . '<esc>`>a<right>' . p[1] . '<esc>'

	endfor

	inoremap <silent> <backspace> <c-r>=pair#del()<cr>

endfunc

