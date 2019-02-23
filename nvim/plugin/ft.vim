" wengwengweng

augroup FTLoad

	autocmd FileType *
				\ call s:load_ft()

	func! s:load_ft()

		let s = expand("<amatch>")

		for name in split(s, '\.')

			exe 'runtime! ftplugin/' . name . '.vim ftplugin/' . name . '/*.vim'
			exe 'runtime! indent/' . name . '.vim indent/' . name . '/*.vim'
			exe 'runtime! syntax/' . name . '.vim syntax/' . name . '/*.vim'

		endfor

	endfunc

augroup END

