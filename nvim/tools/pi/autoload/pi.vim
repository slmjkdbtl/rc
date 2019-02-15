" wengwengweng

func! pi#send()
	call system('sonic-pi-tool eval-file ' . expand('%:p'))
	echo 'buffer sent'
endfunc

func! pi#stop()
	call system('sonic-pi-tool stop')
	echo 'stopped'
endfunc

func! pi#mode()

	runtime! syntax/pi.vim
	map <buffer> <m-r> <Plug>(pi_send)
	map <buffer> <m-s> <Plug>(pi_stop)

endfunc

noremap <silent> <Plug>(pi_send)
			\ :call pi#send()<cr>

noremap <silent> <Plug>(pi_stop)
			\ :call pi#stop()<cr>

