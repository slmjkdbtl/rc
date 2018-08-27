" wengwengweng

func! star#leave()

	call timer_stop(b:timer)

endfunc

func! star#draw(timer)

	setlocal modifiable
	silent! 1,$d

	let width = winwidth('%')
	let height = winheight('%')

	for i in range(height - 14)

		let chars = ''

		for j in range(width)

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
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nocursorline
	setlocal nobuflisted
	setfiletype space
	file space
	call star#draw(0)

	let b:timer = timer_start(96, 'star#draw', {
				\ 'repeat': -1
				\ })

	augroup Star

		autocmd!
		autocmd BufLeave,BufHidden,BufUnload space
					\ call star#leave()

	augroup END

endfunc

