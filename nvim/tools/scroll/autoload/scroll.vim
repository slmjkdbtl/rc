" wengwengweng

func! scroll#scroll(dist)

	let speed = 1

	for i in range(abs(a:dist))

		let start = reltime()

		if a:dist < 0
			exec 'normal! gk'
		else
			exec 'normal! gj'
		endif

		redraw

		let cost = split(reltimestr(reltime(start)), '\.')
		let dt = str2nr(cost[0]) * 1000 + str2nr(cost[1]) / 1000.0
		let snooze = float2nr(g:scroll_duration - dt)

		if snooze > 0
			exec 'sleep ' . snooze . 'm'
		endif

	endfor

endfunc

func! scroll#up()
	call scroll#scroll(-&scroll)
endfunc

func! scroll#down()
	call scroll#scroll(&scroll)
endfunc

noremap <silent> <Plug>(scroll_up)
			\ :call scroll#up()<cr>

noremap <silent> <Plug>(scroll_down)
			\ :call scroll#down()<cr>

