func! open#finder()
	call system('open .')
endfunc

func! open#iterm()
	call system('open -a iTerm ' . escape(getcwd(), ' '))
endfunc

func! open#init()
	command! OpenIterm
		\ call open#iterm()
	command! OpenFinder
		\ call open#finder()
endfunc
