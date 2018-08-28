" wengwengweng

func! s:escape(text)

	let text = a:text
	let text = substitute(text, '\~', '\\~', 'g')
	let text = substitute(text, '\[', '\\[', 'g')
	let text = substitute(text, '\.', '\\.', 'g')
	let text = substitute(text, '\$', '\\$', 'g')
	let text = substitute(text, '\/', '\\/', 'g')

	return text

endfunc

func! s:get_selected() range

	let [ ls, cs ] = getpos("'<")[1:2]
	let [ le, ce ] = getpos("'>")[1:2]

	if ls ==# le

		let line = getline(ls)
		let word = line[(cs - 1):(ce - 1)]

		return word

	else

		return ''

	endif

endfunc

func! s:is_focused()

	if !exists('b:search_pattern')
		return
	endif

	let pos = col('.')
	let line = getline('.')

	return line[(pos - 1) : (pos + len(b:search_pattern) - 2)] =~# b:search_pattern

endfunc

func! s:select()

	if !s:is_focused()
		return
	endif

	exec 'normal! v' . (len(b:search_pattern) - 1) . 'l'

endfunc

func! s:search(text)

	let b:search_pattern = a:text

	if b:search_pattern !=# ''

		let result = search(s:escape(b:search_pattern))

		if !result

			let result = search(s:escape(b:search_pattern), 'b')

			if !result

				redraw
				echo 'no result'

			endif

		endif

	endif

endfunc

func! s:edit_close()

	if b:search_edit_mode ==# 1
		let @q = "\<cr>" . @q
	elseif b:search_edit_mode ==# 2
		let @q = '<' . @q
	elseif b:search_edit_mode ==# 3
		let @q = '>' . @q
	endif

	let b:search_edit_mode = 0

endfunc

func! search#prompt()

	let text = input('search: ')

	call s:search(text)

endfunc

func! search#selected()

	let text = s:get_selected()

	if type(text) == 1 && text !=# ''
		call s:search(text)
	endif

endfunc

func! search#prev()

	if !exists('b:search_pattern')
		return
	endif

	call search(s:escape(b:search_pattern), 'b')

	let b:search_dir = -1

endfunc

func! search#next()

	if !exists('b:search_pattern')
		return
	endif

	call search(s:escape(b:search_pattern))

	let b:search_dir = 1

endfunc

func! search#toggle_record()

	if exists('b:search_edit_mode') && b:search_edit_mode

		normal! q
		call s:edit_close()

	else

		normal! qq

	endif

endfunc

func! search#edit_start(mode)

	call search#selected()

	if !exists('b:search_pattern')
		return
	endif

	let b:search_edit_mode = a:mode

	call s:select()
	normal! qq

	if b:search_edit_mode ==# 1
		exec 'normal! s'
	elseif b:search_edit_mode ==# 2
		exec "normal! \<esc>`<i"
	elseif b:search_edit_mode ==# 3
		exec "normal! \<esc>`>a"
	endif

endfunc

func! search#edit_apply()

	let save = winsaveview()

	if s:is_focused()

		call s:select()
		normal! @q

	else

		if b:search_dir == -1
			let flag = 'b'
		else
			let flag = ''
		endif

		call search(b:search_pattern, 'w' . flag)

		if s:is_focused()

			call s:select()
			normal! @q

		endif

	endif

	call winrestview(save)

endfunc

func! search#bind()

	nnoremap ? :call search#prompt()<cr>
	vnoremap <silent> ? :call search#selected()<cr>
	nnoremap <silent> <m-;> :call search#prev()<cr>
	nnoremap <silent> <m-'> :call search#next()<cr>
	nnoremap <silent> \ :call search#toggle_record()<cr>
	vnoremap <silent> <m-return> :call search#edit_start(1)<cr>a
	vnoremap <silent> <m-<> :call search#edit_start(2)<cr>a
	vnoremap <silent> <m->> :call search#edit_start(3)<cr>a
	nnoremap <silent> <m-.> :call search#edit_apply()<cr>

endfunc

