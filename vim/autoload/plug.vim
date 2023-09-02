" plugin manager

let s:plugdir = get(g:, 'plugdir', fnamemodify($MYVIMRC, ':h') . '/pack/ext/start')
let s:plugins = {}

func! plug#add(repo)
	let name = split(a:repo, '/')[-1]
	let s:plugins[name] = a:repo
endfunc

func! plug#install()
	call mkdir(s:plugdir, 'p')
	redraw | echo 'checking for plugins to install...'
	let l:toinstall = []
	for l:name in keys(s:plugins)
		let l:dir = s:plugdir . '/' . l:name
		if !isdirectory(l:dir)
			let l:toinstall += [ l:name ]
		endif
	endfor
	let l:num = len(l:toinstall)
	if l:num == 0
		redraw | echo 'all packages installed'
		return
	endif
	let l:i in range(l:num)
		let l:name = l:toinstall[i]
		let l:dir = s:plugdir . '/' . l:name
		redraw | echom 'installing ' . l:name . ' (' . (i + 1) . '/' . num . ')'
		call system('git clone ' . 'https://github.com/' . s:plugins[name] . ' ' . l:dir)
	endfor
	redraw | echo 'installed ' . l:num . ' plugins'
endfunc

func! plug#update()
	redraw | echo 'checking for updates...'
	let l:toupdate = []
	let l:pluginnames = keys(s:plugins)
	for l:i in range(len(l:pluginnames))
		let l:name = l:pluginnames[i]
		let l:dir = s:plugdir . '/' . l:name
		redraw | echom 'checking ' . l:name . ' (' . (i + 1) . '/' . len(l:pluginnames) . ')'
		if isdirectory(l:dir)
			call system('cd ' . l:dir . ' && git fetch')
			let l:cur = system('cd ' . l:dir . ' && git rev-parse HEAD ')
			let l:remote = system('cd ' . l:dir . ' && git rev-parse @{u} ')
			if l:cur !=# l:remote
				let l:toupdate += [ l:name ]
			endif
		endif
	endfor
	let l:num = len(l:toupdate)
	if l:num == 0
		redraw | echo 'all plugins up to date'
		return
	endif
	for l:i in range(l:num)
		let l:name = l:toupdate[i]
		let l:dir = s:plugdir . '/' . l:name
		redraw | echom 'updating ' . l:name . ' (' . (i + 1) . '/' . l:num . ')'
		call system('cd ' . l:dir . ' && git pull')
	endfor
	redraw | echo 'updated ' . l:num . ' plugins'
endfunc

func! plug#clean()
	redraw | echo 'checking for unused plugins...'
	let l:count = 0
	let l:entries = glob(s:plugdir . '/*', 0, 1)
	for l:path in l:entries
		let l:name = split(l:path, '/')[-1]
		if !has_key(s:plugins, l:name)
			redraw | echom 'removing ' . l:name
			call system('rm -rf ' . l:path)
			let l:count += 1
		endif
	endfor
	if l:count == 0
		redraw | echo 'no plugin needs to be cleaned'
	else
		redraw | echo 'removed ' . l:count . ' stale plugins'
	endif
endfunc

func! plug#init()
	com! -nargs=1 Plug call plug#add(<args>)
	com! -nargs=0 PlugInstall call plug#install()
	com! -nargs=0 PlugUpdate call plug#update()
	com! -nargs=0 PlugClean call plug#clean()
endfunc
