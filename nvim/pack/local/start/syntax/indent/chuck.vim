" wengwengweng

setlocal nosmartindent
setlocal indentexpr=GetChuckIndent()
setlocal indentkeys=o,=}

func! s:options(list)
	return '\%(' . join(a:list, '\|') . '\)'
endfunc

func! s:start(pat)
	return '^\s*' . a:pat
endfunc

func! s:end(pat)
	return a:pat . '\s*$'
endfunc

func! s:whole(pat)
	return s:start(s:end(a:pat))
endfunc

let s:open = s:options([ s:end('{'), ])
let s:middle = s:options([ s:end('else'), ])
let s:close = s:options([ s:whole('}'), ])

func! GetChuckIndent()

	let line = getline(v:lnum)
	let pnr = prevnonblank(v:lnum - 1)
	let pline = getline(pnr)
	let plen = len(pline)

	if pline =~# s:open && line !~# s:close && line !~# s:middle
		return indent(pnr) + &tabstop
	endif

	if pline =~# s:middle && line !~# s:close
		return indent(pnr) + &tabstop
	endif

	if line =~# s:close || line =~# s:middle

		call cursor(v:lnum, 1)

		return indent(searchpair(s:open, s:middle, s:close, 'bn'))

	endif

	return indent(pnr)

endfunc

