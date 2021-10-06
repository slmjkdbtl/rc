func! s:get_status_mode(bufn)

	let text = ''
	let mode = mode(a:bufn)

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

func! s:get_status_path(bufn)

	let name = bufname(a:bufn)
	let ft = getbufvar(a:bufn, '&filetype')
	let text = ''
	let text .= '%#StatusLine#'

	if mode() ==# 't'
		let text = ''
	else

		let path = fnamemodify(name, ':p')

		if filereadable(path) || isdirectory(path)
			let text = path
		else
			let text = fnamemodify(path, ':h')
		endif

		let text = substitute(text, $HOME, '~', '')

	end

	return text

endfunc

func! s:get_status_modified(bufn)
	if getbufvar(a:bufn, '&modified')
		return '%#StatusLine#[*]'
	else
		return ''
	endif
endfunc

func! s:get_status_filetype(bufn)

	let ft = getbufvar(a:bufn, '&filetype')
	let text = ''

	if ft ==# ''
		let text .= '[*]'
	else
		let text .= '[' . ft . ']'
	endif

	return '%#StatusLine#' . text

endfunc

func! s:get_status_curpos(bufn)
	return '%#StatusLineNC# %l:%c %#StatusLine#'
endfunc

func! statline#get()

	let line = ''
	let line .= s:get_status_mode('%')
	let line .= ' '
	let line .= s:get_status_path('%')
	let line .= ' '
	let line .= s:get_status_modified('%')

	let line .= '%='

	let line .= ' '
	let line .= s:get_status_filetype('%')
	let line .= ' '
	let line .= s:get_status_curpos('%')

	return line

endfunc

func! statline#init()
	set statusline=%!statline#get()
endfunc
