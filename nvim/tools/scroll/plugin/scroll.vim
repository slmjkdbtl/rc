" wengwengweng

let g:scroll_duration = get(g:, 'scroll_duration', 7)

command! -nargs=0 ScrollUp
			\ call scroll#up()

command! -nargs=0 ScrollDown
			\ call scroll#down()

