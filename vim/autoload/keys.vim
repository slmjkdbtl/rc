let s:normal_keys = split("qwertyuiopasdfghjklzxcvbnm1234567890`-=\\;',./", '\zs')
let s:shifted_keys = split("QWERTYUIOPASDFGHJKLZXCVBNM0~!@#$%^&*()_+{}:\"", '\zs')
let s:special_keys = split('cr bs tab left right up down ScrollWheelUp ScrollWheelDown')

" unmap all keys to <nop>
func! keys#unmap()

	" normal keys
	for k in s:normal_keys
		exec 'no ' . k . ' <nop>'
		exec 'no <c-' . k . '> <nop>'
		exec 'no! <c-' . k . '> <nop>'
		exec 'no! <m-' . k . '> <nop>'
	endfor

	" shift+ keys
	for k in s:shifted_keys
		exec 'no ' . k . ' <nop>'
	endfor

	" f keys
	for k in split('1 2 3 4 5 6 7 8 9 10 11 12')
		exec 'no <f' . k . '> <nop>'
		exec 'no! <f' . k . '> <nop>'
	endfor

	" special keys
	for k in s:special_keys
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

	for k in s:normal_keys
		exec 'map <esc>' . k . ' <m-' . k . '>'
		exec 'map! <esc>' . k . ' <m-' . k . '>'
	endfor

	for k in s:special_keys
		exec 'map <esc><' . k . '> <m-' . k . '>'
		exec 'map! <esc><' . k . '> <m-' . k . '>'
	endfor

endfunc

" translate ctrl keys to meta key
func! keys#ctrl2meta()

	for k in s:normal_keys
		exec 'map <c-' . k . '> <m-' . k . '>'
		exec 'map! <c-' . k . '> <m-' . k . '>'
	endfor

	for k in s:special_keys
		exec 'map <c-' . k . '> <m-' . k . '>'
		exec 'map! <c-' . k . '> <m-' . k . '>'
	endfor

endfunc
