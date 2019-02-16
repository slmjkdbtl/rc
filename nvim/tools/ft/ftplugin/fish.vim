" wengwengweng

setlocal commentstring=#%s
inoreabbrev <buffer> <expr> function <sid>function()
inoreabbrev <buffer> <expr> if <sid>if()
inoreabbrev <buffer> <expr> for <sid>for()

func! s:repeat(ch, num)

	let exp = ''

	for i in range(a:num)
		let exp .= a:ch
	endfor

	return exp

endfunc

func! <sid>function()
	return 'function end' . s:repeat("\<left>", 4)
endfunc

func! <sid>if()
	return 'if end' . s:repeat("\<left>", 4)
endfunc

func! <sid>for()
	return 'for end' . s:repeat("\<left>", 4)
endfunc

