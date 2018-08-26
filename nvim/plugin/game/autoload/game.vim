" wengwengweng

func! game#leave()

	if &filetype ==# b:name
		call timer_stop(b:timer)
	endif

endfunc

func! game#update(text)

	let b:lines = a:text

endfunc

func! game#draw(timer)

	setlocal modifiable
	silent! 1,$d

	for i in range(len(b:lines))
		call append(i, b:lines[i])
	endfor

	setlocal nomodifiable
	setlocal nomodified

endfunc

func! game#new(name)

	enew

	let b:name = a:name
	let b:lines = []

	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nocursorline
	setlocal nobuflisted
	exec 'setlocal filetype=' . b:name
	exec 'file ' . b:name

	call game#draw(0)

	let b:timer = timer_start(64, 'game#draw', {
				\ 'repeat': -1
				\ })

endfunc

