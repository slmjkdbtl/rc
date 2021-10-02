func! open#finder()
	call system('open .')
endfunc

func! open#iterm()
	call system('open -a iTerm ' . escape(getcwd(), ' '))
endfunc
