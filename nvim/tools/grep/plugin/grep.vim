" wengwengweng

let g:grep_cmd = get(g:, 'grep_cmd', 'rg --vimgrep')
let g:grep_format = get(g:, 'grep_format', '%f:%l:%c:%m')
let g:find_cmd = get(g:, 'find_cmd', 'fd')

command! -nargs=1 Grep
			\ call grep#search(<q-args>)

