" wengwengweng

setlocal nocindent
setlocal nosmartindent
setlocal autoindent
setlocal indentexpr=GetTODOIndent()
setlocal indentkeys=o,O,

func! GetTODOIndent()

	let pnr = prevnonblank(v:lnum - 1)
	let pline = getline(pnr)

	if pline =~ '^\s*-'
		call feedkeys('- ')
		return indent(pnr)
	endif

endfunc



