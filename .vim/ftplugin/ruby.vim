" wengwengweng

inoreabbrev <buffer> <expr> do <sid>do()
inoreabbrev <buffer> <expr> def <sid>def()

func! s:repeat(ch, num)

	let exp = ''

	for i in range(a:num)
		let exp .= a:ch
	endfor

	return exp

endfunc

func! <sid>do()
	return 'doend' . s:repeat("\<left>", 3)
endfunc

func! <sid>def()
	return 'defend' . s:repeat("\<left>", 3)
endfunc

