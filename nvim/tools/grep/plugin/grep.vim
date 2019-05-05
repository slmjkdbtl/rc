" wengwengweng

let g:grep_cmd = get(g:, 'grep_cmd', 'rg --vimgrep')

command! -nargs=1 Grep
			\ call grep#search(<q-args>)

