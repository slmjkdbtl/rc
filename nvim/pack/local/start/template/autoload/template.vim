" wengwengweng

func! template#auto()

	if exists('&commentstring') && !empty(&commentstring)

		call append(0, substitute(&commentstring, '%s', 'wengwengweng', ''))
		call append(1, '')

	endif

endfunc
