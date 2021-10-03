let s:file = '~/.proj'

func! proj#init()
	command! -nargs=1 Proj call proj#go(<q-args>)
endfunc

func! proj#go(pat)
	for p in readfile(expand(s:file))
		let dir = expand(p)
		if isdirectory(dir) && dir =~ a:pat
			silent! exec 'edit ' . dir
			break
		endif
	endfor
endfunc
