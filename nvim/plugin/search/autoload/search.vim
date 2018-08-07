" wengwengweng

func! search#escape(text)

	let l:text = a:text
	let l:text = substitute(l:text, '\~', '\\~', 'g')
	let l:text = substitute(l:text, '\[', '\\[', 'g')
	let l:text = substitute(l:text, '\.', '\\.', 'g')
	let l:text = substitute(l:text, '\$', '\\$', 'g')
	let l:text = substitute(l:text, '\/', '\\/', 'g')
	let l:text = substitute(l:text, '\*', '\\*', 'g')
	let l:text = substitute(l:text, '\ ', '\\s', 'g')

	return l:text

endfunc

func! search#escapecopy()

	let @" = search#escape(@")

endfunc

func! search#multiedit_replace()
	let g:search_multiedit_mode = 1
endfunc

func! search#multiedit_begin()
	let g:search_multiedit_mode = 2
endfunc

func! search#multiedit_end()
	let g:search_multiedit_mode = 3
endfunc

func! search#multiedit_close()

	normal! q

	if g:search_multiedit_mode == 1

		let @q = "n\<cr>" . @q
		let g:search_multiedit_mode = 0

	elseif g:search_multiedit_mode == 2

		let @q = "n<" . @q
		let g:search_multiedit_mode = 0

	elseif g:search_multiedit_mode == 3

		let @q = "n>" . @q
		let g:search_multiedit_mode = 0

	endif

endfunc

func! search#record()

	if g:search_multiedit_mode
		call search#multiedit_close()
	else
		normal! qq
	endif

endfunc

func! search#bind()

	noremap n gn
	vnoremap <silent> \ ""y:call search#escapecopy()<cr>/<c-r>"<cr>N:noh<cr>qq
	vnoremap <silent> ? ""y:call search#escapecopy()<cr>/<c-r>"<cr>N
	vnoremap <silent> <m-return> ""y:call search#escapecopy()<cr>/<c-r>"<cr>N:noh<cr>:call search#multiedit_replace()<cr>qqgns
	vnoremap <silent> <m-<> ""y:call search#escapecopy()<cr>/<c-r>"<cr>N:noh<cr>:call search#multiedit_begin()<cr>qq`<i
	vnoremap <silent> <m->> ""y:call search#escapecopy()<cr>/<c-r>"<cr>N:noh<cr>:call search#multiedit_end()<cr>qq`>a
	noremap <silent> <m-.> @q
	nnoremap <silent> \ :call search#record()<cr>

endfunc
