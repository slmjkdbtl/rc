" wengwengweng

func! pi#send()
	call system('sonic-pi-tool eval-file ' . expand('%:p'))
endfunc

func! pi#stop()
	call system('sonic-pi-tool stop')
endfunc

func! pi#mode()

	map <buffer><silent> <f8> <Plug>(pi_send)
	map <buffer><silent> <f10> <Plug>(pi_stop)

endfunc

noremap <silent> <Plug>(pi_send)
			\ :call pi#send()<cr>

noremap <silent> <Plug>(pi_stop)
			\ :call pi#stop()<cr>

