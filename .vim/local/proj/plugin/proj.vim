" wengwengweng

let g:proj_file = get(g:, 'proj_file', '~/.projects')

command! -nargs=? Proj
			\ call proj#jump(<q-args>)

command! -nargs=? ProjAdd
			\ call proj#add(<q-args>)

command! -nargs=? ProjRm
			\ call proj#remove(<q-args>)

command! -nargs=0 ProjList
			\ call proj#list()

