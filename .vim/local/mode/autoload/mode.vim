" wengwengweng

let s:items = {}

func! mode#on(name)

	let item = s:items[a:name]

	if !exists('b:modes')
		let b:modes = {}
	endif

	let b:modes[a:name] = 1

	call item.on()
	echo a:name . ' mode on'

endfunc

func! mode#off(name)

	let item = s:items[a:name]

	if !exists('b:modes')
		let b:modes = {}
	endif

	let b:modes[a:name] = 0

	call item.off()
	echo a:name . ' mode off'

endfunc

func! mode#toggle(name)

	if !exists('b:modes')
		let b:modes = {}
	endif

	if !has_key(b:modes, a:name) || b:modes[a:name] ==# 0
		call mode#on(a:name)
	else
		call mode#off(a:name)
	endif

endfunc

func! mode#add(name, on, off)

	let s:items[a:name] = {
		\ 'on': a:on,
		\ 'off': a:off,
		\ }

endfunc

