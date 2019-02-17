" wengwengweng

func! s:scroll(dir) range

	let speed = 1

	for i in range(&scroll)

		let start = reltime()

		if a:dir < 0
			exec 'normal! k'
		else
			exec 'normal! j'
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
	call s:scroll(-1)
endfunc

func! scroll#down()
	call s:scroll(1)
endfunc

