" wengwengweng

func! s:trim(t)
	return substitute(a:t, '\n', '', '')
endfunc

func! s:run(command)
	call jobstart(a:command, {
				\ 'on_exit': function('music#update_status')
				\ })
endfunc

func! music#update_status(...)

	call jobstart('mpc status', {
				\ 'on_stdout': function('music#log')
				\ })

endfunc

func! music#log(j, d, e)

	if empty(join(a:d, ''))
		return
	endif

	if a:d[1] =~# 'playing'
		let g:line_custom_status = s:trim(a:d[0])
	else
		let g:line_custom_status = ''
	endif

endfunc

func! music#play()
	call s:run('mpc play')
endfunc

func! music#pause()
	call s:run('mpc pause')
endfunc

func! music#toggle()
	call s:run('mpc toggle')
endfunc

func! music#prev()
	call s:run('mpc prev')
endfunc

func! music#next()
	call s:run('mpc next')
endfunc

func! music#voldown()
	call system('mpc volume -3')
endfunc

func! music#volup()
	call system('mpc volume +3')
endfunc

func! music#list()
	echo system('mpc playlist')
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

noremap <silent> <Plug>(music_voldown)
			\ :call music#voldown()<cr>

noremap <silent> <Plug>(music_volup)
			\ :call music#volup()<cr>

