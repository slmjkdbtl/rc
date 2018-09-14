" wengwengweng

setlocal nocindent
setlocal nosmartindent
setlocal autoindent
setlocal indentexpr=GetLuaIndent()
setlocal indentkeys=o,O,0},0),=end,=until,=elseif,=else,

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

let s:open = s:options([
			\ s:end('function(.*)'),
			\ s:end('function\s.\+(.*)'),
			\ s:whole('repeat'),
			\ s:end('then'),
			\ s:end('do'),
			\ s:end('{'),
			\ s:end('('),
			\ ])

let s:middle = s:options([
			\ s:whole('else'),
			\ s:start('elseif'),
			\ ])

let s:close = s:options([
			\ s:start('end'),
			\ s:start('until'),
			\ s:start('}'),
			\ s:end(')'),
			\ ])

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

