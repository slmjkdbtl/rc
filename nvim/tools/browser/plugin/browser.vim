" wengwengweng

let g:browser_width = get(g:, 'browser_width', 24)

command! -range Browser
			\ call browser#start()

command! -range BrowserToggle
			\ call browser#toggle()

command! -range BrowserSplit
			\ call browser#start_split()

