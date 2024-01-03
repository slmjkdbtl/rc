" boilerplate code

let g:boilerplates = get(g:, 'boilerplates', {})

func! hi#init()
	com! -nargs=0 Hi call <sid>hi()
endfunc

" TODO: deal with tabs / spaces
func! s:hi()
	if !has_key(g:boilerplates, &ft)
		return
	endif
	let content = g:boilerplates[&filetype]
	call deletebufline('.', 1, '$')
	call setline(1, content)
endfunc
