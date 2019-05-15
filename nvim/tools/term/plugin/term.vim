" wengwengweng

let g:term_buf = get(g:, 'term_buf', 0)
let g:term_win = get(g:, 'term_win', 12)
let g:term_height = get(g:, 'term_height', 12)

command! TermToggle
			\ :call term#toggle()

