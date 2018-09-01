" wengwengweng

func! space#leave()

	call timer_stop(b:timer)

endfunc

func! space#draw(timer)

	setlocal modifiable
	silent! 1,$d

	let width = winwidth(0)
	let height = winheight(0)

	for i in range(height)

		let chars = ''

		for j in range(width - 4)

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

func! space#shine()

	enew
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nocursorline
	setlocal nobuflisted
	setfiletype space
	file space
	call space#draw(0)

	let b:timer = timer_start(96, 'space#draw', {
				\ 'repeat': -1
				\ })

	augroup Space

		autocmd!
		autocmd BufLeave,BufHidden,BufUnload space
					\ call space#leave()

	augroup END

endfunc

