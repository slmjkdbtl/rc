" wengwengweng

func! search#slugify(text)

	let l:text = substitute(a:text, '\~', '\\~', '')
	let l:text = substitute(a:text, '\[', '\\[', '')

	return l:text

endfunc

func! search#slugifycopy()

	let @" = search#slugify(@")

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

func! search#multiedit_end()

	normal! q

	if g:search_multiedit_mode == 1

		let @q = "n\<cr>" . @q
		let g:search_multiedit_mode = 0

	elseif g:search_multiedit_mode == 2

		let @q = "n>" . @q
		let g:search_multiedit_mode = 0

	elseif g:search_multiedit_mode == 3

		let @q = "n<" . @q
		let g:search_multiedit_mode = 0

	endif

endfunc

func! search#bind()

	noremap n gn
	vnoremap <silent> \ y/<c-r>"<cr>N:noh<cr>qq
	vnoremap <silent> ? ""y:call search#slugifycopy()<cr>/<c-r>"<cr>N
	vnoremap <silent> <m-return> ""y:call search#slugifycopy()<cr>/<c-r>"<cr>N:noh<cr>:call search#multiedit_replace()<cr>qqgns
	vnoremap <silent> <m->> ""y:call search#slugifycopy()<cr>/<c-r>"<cr>N:noh<cr>:call search#multiedit_begin()<cr>qq`>a
	vnoremap <silent> <m-<> ""y:call search#slugifycopy()<cr>/<c-r>"<cr>N:noh<cr>:call search#multiedit_end()<cr>qq`<i
	noremap <silent> <m-.> @q
	noremap <silent> \ :call search#multiedit_end()<cr>

endfunc
