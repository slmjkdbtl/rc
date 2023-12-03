" set syntax for custom shebang files

let g:shebangs = get(g:, 'shebangs', [])

func! shebang#init()
	aug SheBang
		au!
		au BufRead *
			\ call <sid>setsyntax()
	aug END
endfunc

func s:setsyntax()
	let line = getline(1)
	if line[0:2] ==# '#!/'
		let prog = line[2:len(line)-1]
		for s in g:shebangs
			if prog =~# s[0]
				exec 'setf ' . s[1]
				break
			endif
		endfor
	endif
endfunc

