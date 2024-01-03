" custom status line

func! s:mode()

	let text = ''
	let mode = mode('%')

	if mode ==# 'n'
		let text .= '%#StatusModeNormal#'
		let text .= ' NORMAL '
	elseif mode ==# 'i'
		let text .= '%#StatusModeInsert#'
		let text .= ' INSERT '
	elseif mode ==# 'v'
		let text .= '%#StatusModeVisual#'
		let text .= ' VISUAL '
	elseif mode ==# 'V'
		let text .= '%#StatusModeVisual#'
		let text .= ' VISUAL '
	elseif mode ==# "\<C-v>"
		let text .= '%#StatusModeVisual#'
		let text .= ' VISUAL '
	elseif mode ==# 'c'
		let text .= '%#StatusModeCommand#'
		let text .= ' COMMAND '
	elseif mode ==# 't'
		let text .= '%#StatusModeTerm#'
		let text .= ' TERMINAL '
	else
		let text .= mode
	endif

	let text .= '%#StatusLine#'

	return text

endfunc

func! s:path()

	let name = bufname('%')
	let ft = getbufvar('%', '&filetype')
	let text = ''
	let text .= '%#StatusLinePath#'

	if mode() ==# 't'
		let text = ''
	else

		let path = fnamemodify(name, ':p')

		if filereadable(path) || isdirectory(path)
			if path[-1:-1] == '/'
				let path = path[0:-2]
			endif
			let text = path
		else
			let text = fnamemodify(path, ':h')
		endif

		let text = substitute(text, $HOME, '~', '')

	end

	if getbufvar('%', '&modified')
		let text .= ' [*]'
	endif

	return text

endfunc

let s:branch = ''

func! s:update_branch()
	let dir = fnamemodify(expand('%:p'), ':h')
	let branch = system('cd ' . dir . ' && git rev-parse --abbrev-ref HEAD')
	if v:shell_error == 0
		let s:branch = '%#StatusLineBranch#' . trim(branch)
		let modified = system('cd ' . dir . ' && git diff-index --quiet HEAD -- >/dev/null 2>&1')
		if v:shell_error != 0
			let s:branch .= '*'
		endif
	else
		let s:branch = ''
	endif
endfunc

func! s:filetype()

	let ft = getbufvar('%', '&filetype')
	let text = ''

	if ft ==# ''
		let text .= '[*]'
	else
		let text .= '[' . ft . ']'
	endif

	return '%#StatusLineFT#' . text

endfunc

func! s:curpos()
	return '%#StatusLineCursor# %l:%c %#StatusLine#'
endfunc

func! statline#get()

	let line = ''
	let line .= s:mode()
	let line .= ' '
	let line .= s:path()
	let line .= ' '
	let line .= s:branch

	let line .= '%='

	let line .= ' '
	let line .= s:filetype()
	let line .= ' '
	let line .= s:curpos()

	return line

endfunc

func! statline#init()
	set statusline=%!statline#get()
	au! BufEnter * call s:update_branch()
endfunc
