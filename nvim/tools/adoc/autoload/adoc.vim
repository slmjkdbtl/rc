" wengwengweng

func! adoc#gen_pdf()

	let input = expand('%:p')
	let out = expand('%:r') . '.pdf'

	let cmd = 'asciidoctor-pdf ' . input

	if exists('g:adoc_theme_file')
		let cmd .= ' -a pdf-theme=' . g:adoc_theme_file
	endif

	if exists('g:adoc_font_dir')
		let cmd .= ' -a pdf-fontsdir=' . g:adoc_font_dir
	endif

	let cmd .= ' -o ' . out

	echo 'writing PDF...'
	echo system(cmd)
	call system('open ' . out)

endfunc

