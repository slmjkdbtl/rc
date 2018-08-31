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

	let pos = col('.')
	let line = getline('.')

	return line[(pos - 1) : (pos + len(@/) - 2)] =~# @/

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

	let b:search_edit_recording = 1

	call s:normal('gnd')
	call s:normal("\<esc>")
	call s:normal('qq')
	call feedkeys('i', 'n')

endfunc

func! search#edit_end()

	if exists('b:search_edit_recording')

		call s:normal('q')
		let @q = @q[0:(len(@q) - 2)]
		unlet b:search_edit_recording

	endif

endfunc

func! search#edit_apply()

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
			call search#edit_apply()
		endif

	endif

endfunc

func! search#bind()

	nnoremap ? /
	vnoremap <silent> ? :call search#selected()<cr>:set hlsearch<cr>
	nnoremap <silent> <m-;> :call search#prev()<cr>:set hlsearch<cr>
	nnoremap <silent> <m-'> :call search#next()<cr>:set hlsearch<cr>
	nnoremap <silent> <m-return> :call search#edit_start()<cr>
	nnoremap <silent> \ :call search#edit_end()<cr>
	nnoremap <silent> <m-.> :call search#edit_apply()<cr>

endfunc

