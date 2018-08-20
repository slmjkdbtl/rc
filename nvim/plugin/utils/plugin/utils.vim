" wengwengweng

command! -nargs=1 Rename
			\ :call utils#rename(<q-args>)

command! -nargs=0 Delete
			\ :call utils#delete()

command! -nargs=1 Copy
			\ :call utils#copy(<q-args>)

command! -nargs=1 Mkdir
			\ :call utils#mkdir(<q-args>)

command! -nargs=0 Close
			\ :call utils#close()

command! -nargs=? Make
			\ :call utils#make(<q-args>)

command! -nargs=0 SynCheck
			\ :call utils#syncheck()

command! -nargs=0 OpenFinder
			\ :call utils#openfinder()

command! -nargs=0 OpenTerm
			\ :call utils#openterm()

