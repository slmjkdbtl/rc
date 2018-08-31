" wengwengweng

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

	let @/ = a:text

endfunc

func! search#selected()

	call s:normal("gv\<esc>")

	let text = s:get_selected()

	if type(text) == 1 && text !=# ''

		call s:search(text)
		call search(@/, 'b')

	endif

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

		let b:record_mode = 1
		let b:recording = 1

		call s:normal('gnd')
		call s:normal("\<esc>")
		call s:normal('qq')
		call feedkeys('i', 'n')

	endif

endfunc

func! search#record_toggle()

	if exists('b:recording') && b:recording && b:record_mode ==# 1

		call s:normal('q')
		let @q = @q[0:(len(@q) - 2)]
		let b:recording = 0

	else

		if exists('b:recording') && b:recording && b:record_mode ==# 2

			call s:normal('q')
			let @q = @q[0:(len(@q) - 2)]
			let b:recording = 0

		else

			call s:normal('qq')
			let b:record_mode = 2
			let b:recording = 1

		endif

	endif

endfunc

func! search#record_apply()

	if b:recording
		return
	endif

	if b:record_mode ==# 1

		if s:is_focused()

			call s:normal('gnd')
			call s:normal("\<esc>")
			call feedkeys('i', 'n')
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

	elseif b:record_mode ==# 2

		call feedkeys(@q)

	endif

endfunc

func! search#bind()

	nnoremap ? /
	vnoremap <silent> ? :call search#selected()<cr>:set hlsearch<cr>
	nnoremap <silent> <m-;> :call search#prev()<cr>
	nnoremap <silent> <m-'> :call search#next()<cr>
	nnoremap <silent> <m-return> :call search#edit_start()<cr>
	nnoremap <silent> \ :call search#record_toggle()<cr>
	nnoremap <silent> <m-.> :call search#record_apply()<cr>
	nnoremap <silent> <m-space> :set hlsearch<cr>

endfunc

