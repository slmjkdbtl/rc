" wengwengweng

augroup title

	autocmd!
	autocmd
		\ VimEnter, DirChanged, BufEnter
		\ *
		\ let &titlestring = line#get_title()

augroup END

set statusline=%!line#get_status()
set tabline=%!line#get_tab()

