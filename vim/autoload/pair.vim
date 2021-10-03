let g:pairs = get(g:, 'pairs', [
	\ ['(', ')'],
	\ ["'", "'"],
	\ ['"', '"'],
	\ ['{', '}'],
	\ ['[', ']'],
\ ])

func! pair#pair(ch1, ch2)

	let line = getline('.')
	let pos = col('.') - 1

	if a:ch1 ==# "'"
		if line[pos - 1] =~# '\w' || line[pos - 1] ==# "'"
			return a:ch1
		endif
	endif

	return a:ch1 . a:ch2 . "\<left>"

endfunc

func! s:inpair()

	let line = getline('.')
	let pos = col('.') - 1

	for w in g:pairs
		if line[pos - 1 : pos] == w[0] . w[1]
			return 1
		endif
	endfor

	return 0

endfunc

func! pair#del()
	if s:inpair()
		return "\<bs>\<del>"
	endif
	return "\<bs>"
endfunc

func! pair#space()
	if s:inpair()
		return "\<space>\<space>\<left>"
	endif
	return "\<space>"
endfunc

func! pair#newline()
	if s:inpair()
		return "\<esc>mqa\<return>\<esc>`qa\<return>"
	endif
	return "\<return>"
endfunc

func! pair#bind()

	for p in g:pairs
		let ech1 = substitute(p[0], "'", "''", 'g')
		let ech2 = substitute(p[1], "'", "''", 'g')
		exec 'inoremap <silent> ' . p[0] . " <c-r>=pair#pair('" . ech1 . "', '" . ech2 . "')<cr>"
		exec 'vnoremap <silent> ' . p[0] . ' <esc>`<i' . p[0] . '<esc>`>a<right>' . p[1] . '<esc>'
	endfor

	inoremap <silent> <space> <c-r>=pair#space()<cr>
	inoremap <silent> <return> <c-r>=pair#newline()<cr>
	inoremap <silent> <bs> <c-r>=pair#del()<cr>

endfunc
