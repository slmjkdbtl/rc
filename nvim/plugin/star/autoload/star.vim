" wengwengweng

func! star#leave()

	if &filetype ==# 'space'
		call timer_stop(b:timer)
	endif

endfunc

func! star#draw(timer)

	setlocal modifiable
	silent! 1,$d

	let width = winwidth('%')
	let height = winheight('%')

	for i in range(height - 1)

		let chars = ''

		for j in range(width - 9)

			let rd = luaeval('math.random()')

			if rd <= 0.05
				let chars .= '.'
			else
				let chars .= ' '
			endif

		endfor

		call append(i, chars)

	endfor

	setlocal nomodifiable
	setlocal nomodified

endfunc

func! star#shine()

	enew
	setlocal filetype=space
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nocursorline
	setlocal nobuflisted
	call star#draw(0)

	let b:timer = timer_start(100, 'star#draw', {'repeat': -1})

endfunc

