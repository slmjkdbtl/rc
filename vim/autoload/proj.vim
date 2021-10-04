let g:proj_file = get(g:, 'proj_file', '~/.proj')

func! proj#init()
	com! -nargs=1 Proj call proj#go(<f-args>)
	com! -nargs=0 ProjEdit call proj#edit()
endfunc

func! proj#go(pat)
	for p in readfile(expand(g:proj_file))
		let dir = expand(p)
		if isdirectory(dir) && dir =~ a:pat
			silent! exec 'edit ' . dir
			break
		endif
	endfor
endfunc

func! proj#edit()
	silent! exec 'edit ' . g:proj_file
endfunc
