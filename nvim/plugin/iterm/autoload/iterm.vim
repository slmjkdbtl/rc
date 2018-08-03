" wengwengweng

let s:dir = resolve(expand('<sfile>:p:h'))

func! s:call_applescript(name, arg)

	let l:fname = s:dir . '/' . a:name . '.applescript'

	if (filereadable(l:fname))
		return system('osascript ' . l:fname . ' ' . a:arg)
	endif

	return -1

endfunc

func! iterm#new_tab()
	return s:call_applescript('new_tab', getcwd())
endfunc
