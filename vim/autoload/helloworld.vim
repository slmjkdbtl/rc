" boilerplate code

let g:boilerplates = get(g:, 'boilerplates', {})

func! helloworld#init()
	com! -nargs=0 Hello call <sid>init()
endfunc

func! s:init()
	if !has_key(g:boilerplates, &ft)
		return
	endif
	let content = g:boilerplates[&filetype]
	call deletebufline('.', 1, '$')
	call setline(1, content)
endfunc
