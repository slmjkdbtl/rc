" wengwengweng

func! s:normal(cmd)

	exec 'normal! ' . a:cmd

endfunc

func! s:escape(text)

	let text = a:text
	let chars = [ '~', '[', '.', '$', '/', '*' ]

	for c in chars
		let text = escape(text, c)
	endfor

	return text

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

	return line[(pos - 1) : (pos + len(@/) - 2)] ==# @/

endfunc

func! s:search(text)

	let @/ = a:text

endfunc

func! search#selected()

	call s:normal("gv\<esc>")

	let text = s:get_selected()

	if type(text) == 1 && text !=# ''

		call s:search(text)
		call search#prev()

	endif

endfunc

func! search#prev()

	call search(s:escape(@/), 'b')

	let b:search_dir = -1

endfunc

func! search#next()

	call search(s:escape(@/))

	let b:search_dir = 1

endfunc

func! search#toggle_record()

	if exists('b:search_edit_mode')
		call s:normal('q')
	else
		call s:normal('qq')
	endif

endfunc

func! search#edit_start(mode)

	call search#selected()
	call s:normal('gn')

	if a:mode ==# 1

		let b:search_edit_mode = 1

		call s:normal('d')
		call s:normal("\<esc>")
		call s:normal('qq')
		call feedkeys('i', 'n')

" 	elseif a:mode ==# 2
"
" 		let b:search_edit_mode = 2
"
" 		call s:normal('`<')
" 		call s:normal("<esc>")
" 		call s:normal('qq')
" 		call feedkeys('i', 'n')
"
" 	elseif a:mode ==# 3
"
" 		let b:search_edit_mode = 3
"
" 		call s:normal('`>')
" 		call s:normal("<esc>")
" 		call s:normal('qq')
" 		call feedkeys('a', 'n')

	endif

endfunc

func! search#edit_apply()

	if s:is_focused()

		if b:search_edit_mode ==# 1

			call s:normal('gn')
			call s:normal('d')
			call s:normal("\<esc>")
			call feedkeys('i', 'n')
			call feedkeys(@q)

" 		elseif b:search_edit_mode ==# 2
"
" 			call s:normal('gn')
" 			call s:normal('`<')
" 			call s:normal("<esc>")
" 			call feedkeys('i', 'n')
" 			call feedkeys(@q)
"
" 		elseif b:search_edit_mode ==# 3
"
" 			call s:normal('gn')
" 			call s:normal('`>')
" 			call s:normal("<esc>")
" 			call feedkeys('a', 'n')
" 			call feedkeys(@q)

		endif

	else
"
		if b:search_dir == -1
			let flag = 'b'
		else
			let flag = ''
		endif
"
		let line = search(s:escape(@/), 'w' . flag)

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
	nnoremap <silent> \ :call search#toggle_record()<cr>
	vnoremap <silent> <m-return> :call search#edit_start(1)<cr>
	vnoremap <silent> <m-<> :call search#edit_start(2)<cr>
	vnoremap <silent> <m->> :call search#edit_start(3)<cr>
	nnoremap <silent> <m-.> :call search#edit_apply()<cr>

endfunc

