" wengwengweng

func! s:trim(t)
	return substitute(a:t, '\n', '', '')
endfunc

func! s:run(command)
	call jobstart(a:command, {
				\ 'on_exit': function('music#log')
				\ })
endfunc

func! music#play()

	call s:run('mpc play')

endfunc

func! music#log(j, d, e)

	call jobstart('mpc current', {
				\ 'on_stdout': function('music#update_status')
				\ })

endfunc

func! music#update_status(j, d, e)

	if empty(a:d[0])
		return
	endif

	let g:line_custom_status = s:trim(a:d[0])

endfunc

func! music#pause()

	call jobstart('mpc pause')
	let g:line_custom_status = ''

endfunc

func! music#toggle()

	call jobstart('mpc toggle')

endfunc

func! music#prev()

	call s:run('mpc prev')

endfunc

func! music#next()

	call s:run('mpc next')

endfunc

noremap <silent> <Plug>(music_play)
			\ :call music#play()<cr>

noremap <silent> <Plug>(music_pause)
			\ :call music#pause()<cr>

noremap <silent> <Plug>(music_toggle)
			\ :call music#toggle()<cr>

noremap <silent> <Plug>(music_prev)
			\ :call music#prev()<cr>

noremap <silent> <Plug>(music_next)
			\ :call music#next()<cr>

