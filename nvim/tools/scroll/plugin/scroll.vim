" wengwengweng

let g:scroll_duration = get(g:, 'scroll_duration', 12)

command! -nargs=1 Scroll
			\ call scroll#scroll(<q-args>)

command! -nargs=0 ScrollUp
			\ call scroll#up()

command! -nargs=0 ScrollDown
			\ call scroll#down()

