" wengwengweng

let s:syntax_dir = expand('~/.vimextern/syntax')
let s:indent_dir = expand('~/.vimextern/indent')

func! ft#detect(pat, ft)

	exec 'autocmd BufNewFile,BufRead ' . a:pat . ' '
				\ . 'setlocal filetype=' . a:ft

endfunc

func! ft#comment(ft, comment, alt)

	let comments = ''

	for c in a:alt
		let comments .= ',b:' . c
	endfor

	exec 'autocmd FileType ' . a:ft . ' '
				\ . 'setlocal commentstring=' . a:comment . '%s'
				\ . ' | '
				\ . 'setlocal comments=b:' . a:comment . comments

endfunc

