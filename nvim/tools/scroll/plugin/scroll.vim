" wengwengweng

let g:scroll_duration = get(g:, 'scroll_duration', 8)

command! -nargs=1 -range Scroll
			\ call scroll#scroll(<q-args>)

