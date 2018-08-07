" wengwengweng

if exists('g:colors_name')

	if g:colors_name == 'OceanicNext'

		hi! vimfilerNormalFile guibg=none
		hi! vimUserFunc guibg=none
		hi! TabLine gui=none
		hi! TabLineSel guibg=none
		hi! link TabLineFill TabLine
		hi! Error guibg=#e66a74
		hi! link NvimInternalError Error

	endif

endif

if has('gui_macvim')

	augroup macvimcolors
		autocmd!
		autocmd VimEnter * hi! LineNr guibg=MacTextBackgroundColor
	augroup END

endif
