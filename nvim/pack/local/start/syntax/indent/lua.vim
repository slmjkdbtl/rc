" wengwengweng

setlocal nocindent
setlocal nosmartindent
setlocal indentexpr=GetLuaIndent()
setlocal indentkeys=o,0=end,0=until,0=elseif,0=else,0=}

func! s:options(list)
	return '\%(' . join(a:list, '\|') . '\)'
endfunc

func! s:end(pat)
	return a:pat . '\s*$'
endfunc

let s:open = s:options([ s:end('function()'), s:end('function\s.\+(.*)'), s:end('repeat'), s:end('then'), s:end('do'), s:end('{'), ])
let s:middle = s:options([ s:end('else'), s:end('elseif'), ])
let s:close = s:options([ s:end('end'), 'until', s:end('}'), ])

func! GetLuaIndent()

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

