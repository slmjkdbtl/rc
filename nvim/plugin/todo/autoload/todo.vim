" wengwengweng

func! todo#view()

	if !filereadable(g:todo_file)

		echoerr "can't read todo file"
		return -1

	endif

endfunc

