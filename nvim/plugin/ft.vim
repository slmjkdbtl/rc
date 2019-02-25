" wengwengweng

augroup FTLoad

	autocmd FileType *
				\ call s:load_ft()

	autocmd Syntax *
				\ syntax clear

	func! s:load_ft()

		let s = expand("<amatch>")

		for name in split(s, '\.')

			exec 'runtime! ftplugin/' . name . '.vim ftplugin/' . name . '/*.vim'
			exec 'runtime! indent/' . name . '.vim indent/' . name . '/*.vim'
			exec 'runtime! syntax/' . name . '.vim syntax/' . name . '/*.vim'

		endfor

	endfunc

augroup END

