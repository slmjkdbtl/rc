" wengwengweng

func! grep#search(txt)

	let l:grepprgb = &grepprg
	let &grepprg = g:grep_cmd

	let l:te = &t_te
	let l:ti = &t_ti
	set t_te=
	set t_ti=

	let l:opts = ' '

	if &ignorecase == 1
		let l:opts = l:opts . '-i '
	endif

	if &smartcase == 1
		let l:opts = l:opts . '-S '
	endif

	silent! exe 'grep! ' . l:opts . '"' . a:txt . '"'
    exe 'botright copen'
" 	echom getqflist()

	let &t_te=l:te
	let &t_ti=l:ti
	let &grepprg = l:grepprgb

endfunc

