" wengwengweng

let s:srcdir = expand('<sfile>:p:h:h')

func! ft#add(pat, ft, repo, comment)

	let g:syntax_list += [{
				\ 'pat': a:pat,
				\ 'ft': a:ft,
				\ 'repo': a:repo,
				\ 'comment': a:comment,
				\ }]

endfunc

func! ft#load()

	augroup Syntax

		autocmd!

		for s in g:syntax_list

			exec 'autocmd BufNewFile,BufRead ' . s.pat . ' '
						\ . 'setlocal filetype=' . s.ft . '|'
						\ . 'setlocal commentstring=' . s.comment

		endfor

	augroup END

endfunc

func! ft#download()

	for s in g:syntax_list

		if !exists('s.repo') || s.repo ==# ''
			continue
		endif

		let args = '--fail --create-dir'
		let syntax_url = 'https://raw.githubusercontent.com/' . s.repo . '/master/syntax/' . s.ft . '.vim'
" 		let indent_url = 'https://raw.githubusercontent.com/' . s.repo . '/master/indent/' . s.ft . '.vim'
		let syntax_file = s:srcdir . '/syntax/' . s.ft . '.vim'
" 		let indent_file = s:srcdir . '/indent/' . s.ft . '.vim'

		call system('curl ' . args . ' ' . syntax_url . ' -o ' . syntax_file)

		if v:shell_error ==# 0
			" ...
		endif

" 		call system('curl ' . args . ' ' . indent_url . ' -o ' . indent_file)

" 		if v:shell_error ==# 0
			" ...
" 		endif

	endfor

endfunc

