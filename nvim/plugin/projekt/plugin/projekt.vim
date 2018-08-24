" wengwengweng

let g:projekt_file = get(g:, 'projekt_file', '~/.projekts')

command! -nargs=? Projekt
			\ call projekt#jump(<q-args>)

command! -nargs=? ProjektAdd
			\ call projekt#add(<q-args>)

command! -nargs=? ProjektRemove
			\ call projekt#remove(<q-args>)

command! -nargs=? ProjektStar
			\ call projekt#star(<q-args>)

command! -nargs=0 ProjektList
			\ call projekt#list()

