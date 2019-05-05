" wengwengweng

func! space#draw(timer)

	if !exists('*luaeval')
		return
	endif

	if &ft !=# 'space'
		return
	endif

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

func! space#start()

	let g:space_timer = timer_start(96, 'space#draw', {
				\ 'repeat': -1
				\ })

endfunc

func! space#stop()

	call timer_stop(g:space_timer)

endfunc

func! space#shine()

	call view#new()
	setlocal nocursorline
	setfiletype space
	call space#draw(0)
	call space#start()

endfunc

