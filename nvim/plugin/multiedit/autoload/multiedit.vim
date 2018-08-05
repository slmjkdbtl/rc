" wengwengweng

func! multiedit#start_replace()
	let g:multiedit_mode = 1
endfunc

func! multiedit#start_begin()
	let g:multiedit_mode = 2
endfunc

func! multiedit#start_end()
	let g:multiedit_mode = 3
endfunc

func! multiedit#end()

	normal! q

	if g:multiedit_mode == 1

		let @q = "n\<cr>" . @q
		let g:multiedit_mode = 0

	elseif g:multiedit_mode == 2

		let @q = "n>" . @q
		let g:multiedit_mode = 0

	elseif g:multiedit_mode == 3

		let @q = "n<" . @q
		let g:multiedit_mode = 0

	endif

endfunc

func! multiedit#bind()

	noremap n gn
	vnoremap <silent> \ y/<c-r>"<cr>N:noh<cr>qq
	vnoremap <silent> <m-return> y/<c-r>"<cr>N:noh<cr>:call multiedit#start_replace()<cr>qqgns
	vnoremap <silent> <m->> y/<c-r>"<cr>N:noh<cr>:call multiedit#start_begin()<cr>qq`>a
	vnoremap <silent> <m-<> y/<c-r>"<cr>N:noh<cr>:call multiedit#start_end()<cr>qq`<i
	noremap <silent> <m-.> @q
	noremap <silent> \ :call multiedit#end()<cr>

endfunc
