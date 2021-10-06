" unmap all keys to <nop>
func! keys#unmap()

	" normal keys
	for k in split("qwertyuiopasdfghjklzxcvbnm1234567890`-=\\;',./", '\zs')
		exec 'no ' . k . ' <nop>'
		exec 'no <c-' . k . '> <nop>'
		exec 'no! <c-' . k . '> <nop>'
		exec 'no! <m-' . k . '> <nop>'
	endfor

	" shift+ keys
	for k in split("QWERTYUIOPASDFGHJKLZXCVBNM0~!@#$%^&*()_+{}:\"", '\zs')
		exec 'no ' . k . ' <nop>'
	endfor

	" f keys
	for k in split('1 2 3 4 5 6 7 8 9 10 11 12')
		exec 'no <f' . k . '> <nop>'
		exec 'no! <f' . k . '> <nop>'
	endfor

	" special keys
	for k in split('cr bs tab left right up down')
		exec 'no <' . k . '> <nop>'
		exec 'no! <' . k . '> <nop>'
	endfor

	" leftovers
	no [ <nop>
	no ] <nop>
	no " <nop>
	no < <nop>
	no > <nop>
	no ? <nop>

endfunc

" translate esc+ keys to meta key
func! keys#esc2meta()

	for k in split("qwertyuiopasdfghjklzxcvbnm1234567890`-=\\;',./", '\zs')
		exec 'map <esc>' . k . ' <m-' . k . '>'
		exec 'map! <esc>' . k . ' <m-' . k . '>'
	endfor

	for k in split('cr bs tab left right up down ScrollWheelUp ScrollWheelDown')
		exec 'map <esc><' . k . '> <m-' . k . '>'
		exec 'map! <esc><' . k . '> <m-' . k . '>'
	endfor

endfunc

" translate ctrl keys to meta key
func! keys#ctrl2meta()

	for k in split("qwertyuiopasdfghjklzxcvbnm1234567890`-=\\;',./", '\zs')
		exec 'map <c-' . k . '> <m-' . k . '>'
		exec 'map! <c-' . k . '> <m-' . k . '>'
	endfor

	for k in split('cr bs tab left right up down ScrollWheelUp ScrollWheelDown')
		exec 'map <c-' . k . '> <m-' . k . '>'
		exec 'map! <c-' . k . '> <m-' . k . '>'
	endfor

endfunc
