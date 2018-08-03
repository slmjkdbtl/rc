" wengwengweng

func! s:get_tab_title(bufn)

	let l:name = bufname(a:bufn)
	let l:ft = getbufvar(a:bufn, '&ft')
	let l:text = ''

	if l:ft ==# 'vimfiler'
		let l:text = 'filer'
" 		let l:text = fnamemodify(l:name, ':p:h:t')
	else
		let l:text = fnamemodify(l:name, ':t')
	endif

	return l:text

endfunc

func! s:get_tab_modified(bufn)

	if getbufvar(a:bufn, '&modified')
		return ' [~]'
	else
		return ''
	end

endfunc

func! s:get_status_mode(bufn)

	let l:text = ''
	let l:mode = mode(a:bufn)

	if l:mode ==# 'n'

		let l:text .= '%#StatusModeNormal#'
		let l:text .= ' NORMAL '

	elseif l:mode ==# 'i'

		let l:text .= '%#StatusModeInsert#'
		let l:text .= ' INSERT '

	elseif l:mode ==? 'v'

		let l:text .= '%#StatusModeVisual#'
		let l:text .= ' VISUAL '

	elseif l:mode ==# 'CTRL-V'

		let l:text .= '%#StatusModeVisual#'
		let l:text .= ' V-BLOCK '

	else

		let l:text .= l:mode

	endif

	let l:text .= '%#StatusLine#'

	return l:text

endfunc

func! s:get_status_path(bufn)

	let l:name = bufname(a:bufn)
	let l:ft = getbufvar(a:bufn, '&ft')
	let l:text = ''
	let l:text .= '%#StatusLine#'

	if l:ft ==# 'vimfiler'
		let l:text = fnamemodify(l:name, ':p:h')
	elseif l:ft ==# 'ctrlp'
		let l:text = 'searching...'
	else
		let l:text = fnamemodify(l:name, ':p')
	endif

	let l:text = substitute(l:text, '/Users/\w*', '~', '')

	return l:text

endfunc

func! s:get_status_modified(bufn)

	if getbufvar(a:bufn, '&modified')
		return '%#StatusLine#[~]'
	else
		return ''
	endif

endfunc

func! s:get_status_filetype(bufn)

	let l:ft = getbufvar(a:bufn, '&ft')
	let l:text = ''

	if l:ft == ''
		let l:text .= '[*]'
	else
		let l:text .= '[' . l:ft . ']'
	endif

	return '%#StatusLine#' . l:text

endfunc

func! s:get_status_curpos(bufn)

	return '%#StatusLineNC# %l:%c %#StatusLine#'

endfunc

func! line#get_title()

	let l:bufn = tabpagebuflist(tabpagenr())[0]
	let l:name = bufname(l:bufn)
	let l:ft = getbufvar(l:bufn, '&ft')
	let l:text = ''

	if l:ft ==# 'vimfiler'
		let l:text = fnamemodify(l:name, ':p:h:t')
	else
		let l:text = fnamemodify(l:name, ':t')
	endif

	return l:text

endfunc

func! line#get_tab()

	let l:line = ''

	for l:i in range(tabpagenr('$'))

		let l:bufn = tabpagebuflist(l:i + 1)[0]
		let l:bufname = bufname(l:bufn)

		if l:i + 1 == tabpagenr()
			let l:line .= '%#TabLineSel#'
		else
			let l:line .= '%#TabLine#'
		endif

		let l:line .= ' '
		let l:line .= s:get_tab_title(l:bufn)
		let l:line .= s:get_tab_modified(l:bufn)
		let l:line .= ' '

	endfor

	let l:line .= '%#TabLineFill#'

	return l:line

endfunc

func! line#get_status()

	let l:line = ''
	let l:line .= s:get_status_mode('%')
	let l:line .= ' '
	let l:line .= s:get_status_path('%')
	let l:line .= ' '
	let l:line .= s:get_status_modified('%')

	let l:line .= '%='

	let l:line .= s:get_status_filetype('%')
	let l:line .= ' '
	let l:line .= s:get_status_curpos('%')

	return l:line

endfunc
