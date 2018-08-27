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

	if !exists('b:pattern')
		return
	endif

	let pos = col('.')
	let line = getline('.')

	return line[(pos - 1) : (pos + len(b:pattern) - 2)] =~# b:pattern

endfunc

func! s:select()

	if !s:is_focused()
		return
	endif

	exec 'normal! v' . (len(b:pattern) - 1) . 'l'

endfunc

func! s:search(text)

	let b:pattern = a:text

	if b:pattern !=# ''

		let result = search(s:escape(b:pattern))

		if !result
			redraw!
			echo 'no result'
		endif

	endif

endfunc

func! s:edit_close()

	if b:edit_mode ==# 1
		let @q = "\<cr>" . @q
	elseif b:edit_mode ==# 2
		let @q = '<' . @q
	elseif b:edit_mode ==# 3
		let @q = '>' . @q
	endif

	let b:edit_mode = 0

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

	if !exists('b:pattern')
		return
	endif

	call search(s:escape(b:pattern), 'b')

endfunc

func! search#next()

	if !exists('b:pattern')
		return
	endif

	call search(s:escape(b:pattern))

endfunc

func! search#toggle_record()

	if b:edit_mode

		normal! q
		call s:edit_close()

	else

		normal! qq

	endif

endfunc

func! search#edit_start(mode)

	call search#selected()

	if !exists('b:pattern')
		return
	endif

	let b:edit_mode = a:mode

	call s:select()
	normal! qq

	if b:edit_mode ==# 1
		exec 'normal! s'
	elseif b:edit_mode ==# 2
		exec "normal! \<esc>`<i"
	elseif b:edit_mode ==# 3
		exec "normal! \<esc>`>a"
	endif

endfunc

func! search#edit_apply()

	if s:is_focused()

		call s:select()
		normal! @q

	else

		call search(b:pattern, 'w')

		if s:is_focused()

			call s:select()
			normal! @q

		endif

	endif

endfunc

func! search#bind()

	noremap ? :call search#prompt()<cr>
	vnoremap <silent> ? :call search#selected()<cr>
	noremap <silent> <m-;> :call search#prev()<cr>
	noremap <silent> <m-'> :call search#next()<cr>
	noremap <silent> \ :call search#toggle_record()<cr>
	vnoremap <silent> <m-return> :call search#edit_start(1)<cr>a
	vnoremap <silent> <m-<> :call search#edit_start(2)<cr>a
	vnoremap <silent> <m->> :call search#edit_start(3)<cr>a
	noremap <silent> <m-.> :call search#edit_apply()<cr>

endfunc
