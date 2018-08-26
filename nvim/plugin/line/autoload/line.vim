" wengwengweng

func! s:get_tab_title(bufn)

	let text = fnamemodify(bufname(a:bufn), ':t')

	if text ==# ''
		let text = '*'
	endif

	return text

endfunc

func! s:get_tab_modified(bufn)

	if getbufvar(a:bufn, '&modified')
		return ' [~]'
	else
		return ''
	end

endfunc

func! s:get_status_mode(bufn)

	let text = ''
	let mode = mode(a:bufn)

	if mode ==# 'n'

		let text .= '%#StatusModeNormal#'
		let text .= ' NORMAL '

	elseif mode ==# 'i'

		let text .= '%#StatusModeInsert#'
		let text .= ' INSERT '

	elseif mode ==? 'v'

		let text .= '%#StatusModeVisual#'
		let text .= ' VISUAL '

	elseif mode ==# 'CTRL-V'

		let text .= '%#StatusModeVisual#'
		let text .= ' V-BLOCK '

	elseif mode ==# 'c'

		let text .= '%#StatusModeCommand#'
		let text .= ' COMMAND '

	elseif mode ==# 't'

		let text .= '%#StatusModeTerminal#'
		let text .= ' TERMINAL '
	else

		let text .= mode

	endif

	let text .= '%#StatusLine#'

	return text

endfunc

func! s:get_status_path(bufn)

	let name = bufname(a:bufn)
	let ft = getbufvar(a:bufn, '&ft')
	let text = ''
	let text .= '%#StatusLine#'

	if mode() ==# 't'

		let text = ''

	else

		if ft ==# 'ctrlp'

			let text = 'searching...'

		else

			let path = fnamemodify(name, ':p')

			if filereadable(path)
				let text = path
			else
				let text = name
			endif

		endif

		let text = substitute(text, '/Users/\w*', '~', '')

	end

	return text

endfunc

func! s:get_status_modified(bufn)

	if getbufvar(a:bufn, '&modified')
		return '%#StatusLine#[~]'
	else
		return ''
	endif

endfunc

func! s:get_status_filetype(bufn)

	let ft = getbufvar(a:bufn, '&ft')
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

func! line#get_title()

	let bufn = tabpagebuflist(tabpagenr())[0]
	let name = bufname(bufn)
	let ft = getbufvar(bufn, '&ft')
	let text = ''

	if ft ==# 'vimfiler'
		let text = fnamemodify(name, ':p:h:t')
	else
		let text = fnamemodify(name, ':t')
	endif

	return text

endfunc

func! line#get_tab()

	let line = ''

	for i in range(tabpagenr('$'))

		let bufn = tabpagebuflist(i + 1)[0]
		let bufname = bufname(bufn)

		if i + 1 == tabpagenr()
			let line .= '%#TabLineSel#'
		else
			let line .= '%#TabLine#'
		endif

		let line .= ' '
		let line .= s:get_tab_title(bufn)
		let line .= s:get_tab_modified(bufn)
		let line .= ' '

	endfor

	let line .= '%#TabLineFill#'

	return line

endfunc

func! line#get_status()

	let line = ''
	let line .= s:get_status_mode('%')
	let line .= ' '
	let line .= s:get_status_path('%')
	let line .= ' '
	let line .= s:get_status_modified('%')

	let line .= '%='

	let line .= s:get_status_filetype('%')
	let line .= ' '
	let line .= s:get_status_curpos('%')

	return line

endfunc
