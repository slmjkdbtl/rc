" wengwengweng

func! bufline#get_tabline() abort

	let line = ''

	for b in getbufinfo({ 'buflisted': 1 })

		if b.bufnr ==# bufnr('%')
			let line .= '%#TabLineSel#'
		else
			let line .= '%#TabLine#'
		endif

		let line .= ' '
		let line .= fnamemodify(b.name, ':t')

		if b.changed
			let line .= ' [~]'
		endif

		let line .= ' '

	endfor

	let line .= '%#TabLineFill#'

	return line

endfunc

set tabline=%!bufline#get_tabline()
