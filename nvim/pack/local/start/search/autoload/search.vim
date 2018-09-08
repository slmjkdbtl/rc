" wengwengweng

func! s:escape(text)

	return escape(a:text, '~.*[')

endfunc

func! s:normal(cmd)

	exec 'normal! ' . a:cmd

endfunc

func! s:get_selected() range

	if a:firstline ==# a:lastline

		let c1 = col("'<")
		let c2 = col("'>")

		return getline('.')[(c1 - 1) : (c2 - 1)]

	else

		return ''

	endif

endfunc

func! s:is_focused()

	return searchpos(@/, 'cn') ==# [ line('.'), col('.') ]

endfunc

func! s:search(text)

	let @/ = s:escape(a:text)

endfunc

func! search#selected()

	call s:normal("gv\<esc>")

	let text = s:get_selected()

	call s:search(text)
	call search(@/, 'b')

endfunc

func! search#prev()

	call search(@/, 'b')

	let b:search_dir = -1

endfunc

func! search#next()

	call search(@/)

	let b:search_dir = 1

endfunc

func! search#edit_start()

	if s:is_focused()

		let b:recording = 1
		let g:record_mode = 1
		let g:record_startkeys = ''

		call s:normal('gn')
		call s:normal('qq')

	endif

endfunc

func! search#edit_start_selected()

	call search#selected()
	call search#edit_start()
	call feedkeys('s', 'n')
	let g:record_startkeys = 's'

endfunc

func! search#record_toggle()

	let b:recording = get(b:, 'recording', 0)
	let g:record_mode = get(g:, 'record_mode', 0)

	if b:recording && g:record_mode ==# 1

		call s:normal('q')
		let @q = @q[0:(len(@q) - 2)]
		let b:recording = 0

	else

		if b:recording && g:record_mode ==# 2

			call s:normal('q')
			let @q = @q[0:(len(@q) - 2)]
			let b:recording = 0

		else

			call s:normal('qq')
			let g:record_mode = 2
			let b:recording = 1

		endif

	endif

endfunc

func! search#record_apply()

	if exists('b:recording') && b:recording
		return
	endif

	if !exists('g:record_mode')
		return
	endif

	if g:record_mode ==# 1

		if s:is_focused()

			call s:normal('gn')
			call feedkeys(get(g:, 'record_startkeys', ''), 'n')
			call feedkeys(@q)

		else
	"
			if exists('b:search_dir') && b:search_dir ==# -1
				let flag = 'b'
			else
				let flag = ''
			endif
	"
			let line = search(@/, 'w' . flag)

			if line
				call search#record_apply()
			endif

		endif

	elseif g:record_mode ==# 2

		call feedkeys(@q)

	endif

endfunc

func! search#bind()

	nnoremap ? /
	vnoremap <silent> ? :call search#selected()<cr>:set hlsearch<cr>
	nnoremap <silent> <m-;> :call search#prev()<cr>
	nnoremap <silent> <m-'> :call search#next()<cr>
	nnoremap <silent> <m-\> :call search#edit_start()<cr>
	vnoremap <silent> <m-return> :call search#edit_start_selected()<cr>
	nnoremap <silent> \ :call search#record_toggle()<cr>
	nnoremap <silent> <m-.> :call search#record_apply()<cr>
	nnoremap <silent> <m-space> :set hlsearch<cr>

endfunc

