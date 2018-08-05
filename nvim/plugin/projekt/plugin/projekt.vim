" wengwengweng

let g:projekt_file = get(g:, 'projekt_file', '~/.projekts')
let g:projekt_switch_action = get(g:, 'projekt_switch_action', '')

command! -nargs=? Projekt :call projekt#jump(<q-args>)
command! -nargs=? ProjektAdd :call projekt#add(<q-args>)
command! -nargs=? ProjektRemove :call projekt#remove(<q-args>)
command! -nargs=? ProjektStar :call projekt#star(<q-args>)
command! -nargs=0 ProjektList :call projekt#list()
