" wengwengweng

let g:grep_cmd = get(g:, 'grep_cmd', 'rg --vimgrep')
let g:grep_format = get(g:, 'grep_format', '%f:%l:%c:%m')
let g:find_cmd = get(g:, 'find_cmd', 'fd')
let g:find_max_height = get(g:, 'find_max_height', 16)
let g:find_min_input = get(g:, 'find_min_input', 2)
let g:find_win_top = get(g:, 'find_win_pos', 0)

command! Find
			\ call find#find()

command! Grep
			\ call find#grep()

