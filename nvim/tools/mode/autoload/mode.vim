" wengwengweng

let s:items = {}

func! mode#toggle(name)

	let item = s:items[a:name]

	if !exists('b:modes')
		let b:modes = {}
	endif

	if !has_key(b:modes, a:name)
		let b:modes[a:name] = 0
	endif

	let status = b:modes[a:name]

	if status == 0

		let b:modes[a:name] = 1
		call item.on()
		echo a:name . ' mode on'

	elseif status == 1

		let b:modes[a:name] = 0
		call item.off()
		echo a:name . ' mode off'

	endif

endfunc

func! mode#add(name, on, off)

	let s:items[a:name] = {
		\ 'on': a:on,
		\ 'off': a:off,
		\ }

endfunc

