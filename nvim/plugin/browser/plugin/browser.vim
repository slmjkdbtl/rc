" wengwengweng

let s:srcdir = expand('<sfile>:p:h:h')

exec 'set rtp^=' . s:srcdir . ''

command! -nargs=* -range Browser
			\ call browser#open()

