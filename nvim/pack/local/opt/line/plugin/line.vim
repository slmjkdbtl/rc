" wengwengweng

augroup Title

	autocmd!

	autocmd DirChanged, BufEnter, BufLeave *
		\ let &titlestring = line#get_title()

augroup END

set statusline=%!line#get_statusline()
set tabline=%!line#get_bufline()

