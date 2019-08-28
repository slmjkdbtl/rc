" wengwengweng

func! space#draw(timer)

	if !exists('*luaeval')
		return
	endif

	if &ft !=# 'space'
		return
	endif

	setlocal modifiable
	silent! %d

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

func! space#stop()

	if get(g:, 'space_timer')
		call timer_stop(g:space_timer)
	endif

endfunc

func! space#start()

	noautocmd enew
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nocursorcolumn
	setlocal nocursorline
	setlocal nobuflisted
	setlocal nolist
	setlocal nonumber
	setlocal norelativenumber
	setlocal nospell
	setlocal colorcolumn=
	setlocal foldcolumn=0
	setlocal matchpairs=
	setlocal noswapfile
	setlocal nonumber
	setlocal signcolumn=no
	setlocal nomodifiable
	setlocal nomodified
	setlocal nowrap
	setlocal statusline=\ space
	setfiletype space
	call space#draw(0)

	call space#stop()

	let g:space_timer = timer_start(96, 'space#draw', {
				\ 'repeat': -1
				\ })

endfunc

