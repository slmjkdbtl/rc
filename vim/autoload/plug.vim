let s:basepath = fnamemodify($MYVIMRC, ':h')

func! plug#load(path)
	exec 'set runtimepath+=' . s:basepath . '/' . a:path
endfunc
