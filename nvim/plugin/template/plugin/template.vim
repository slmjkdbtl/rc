" wengwengweng

let g:template_path = get(g:, 'template_path', '~/.config/nvim/templates')

augroup templates

	autocmd!

	let files = split(glob(expand(g:template_path) . '/*'))

	for f in files
		exec 'autocmd BufNewFile ' . fnamemodify(f, ':t') . ' 0r ' . f . ' | normal! G'
	endfor

augroup END

