" plugin manager

let s:plugdir = get(g:, 'plugdir', fnamemodify($MYVIMRC, ':h') . '/pack/ext/opt')
let s:plugins = {}

func! plug#add(repo)
	let name = split(a:repo, '/')[-1]
	let s:plugins[name] = a:repo
	exec 'packadd ' . name
endfunc

func! plug#install()
	call mkdir(s:plugdir, 'p')
	redraw | echo 'checking for plugins to install...'
	let toinstall = []
	for name in keys(s:plugins)
		let dir = s:plugdir . '/' . name
		if !isdirectory(dir)
			let toinstall += [ name ]
		endif
	endfor
	let num = len(toinstall)
	if num == 0
		redraw | echo 'all packages installed'
		return
	endif
	for i in range(num)
		let name = toinstall[i]
		let dir = s:plugdir . '/' . name
		redraw | echo 'installing ' . name . ' (' . (i + 1) . '/' . num . ')'
		call system('git clone ' . 'https://github.com/' . s:plugins[name] . ' ' . dir)
	endfor
	redraw | echom 'installed ' . num . ' plugins: ' . join(toinstall, ', ')
endfunc

func! plug#update()
	redraw | echo 'checking for updates...'
	let toupdate = []
	let pluginnames = keys(s:plugins)
	for i in range(len(pluginnames))
		let name = pluginnames[i]
		let dir = s:plugdir . '/' . name
		redraw | echo 'checking ' . name . ' (' . (i + 1) . '/' . len(pluginnames) . ')'
		if isdirectory(dir)
			call system('cd ' . dir . ' && git fetch')
			let cur = system('cd ' . dir . ' && git rev-parse HEAD ')
			let remote = system('cd ' . dir . ' && git rev-parse @{u} ')
			if cur !=# remote
				let toupdate += [ name ]
			endif
		endif
	endfor
	let num = len(toupdate)
	if num == 0
		redraw | echo 'all plugins up to date'
		return
	endif
	for i in range(num)
		let name = toupdate[i]
		let dir = s:plugdir . '/' . name
		redraw | echo 'updating ' . name . ' (' . (i + 1) . '/' . num . ')'
		call system('cd ' . dir . ' && git pull')
	endfor
	redraw | echom 'updated ' . num . ' plugins: ' . join(toupdate, ', ')
endfunc

func! plug#clean()
	redraw | echo 'checking for unused plugins...'
	let entries = glob(s:plugdir . '/*', 0, 1)
	let removed = []
	for path in entries
		let name = split(path, '/')[-1]
		if !has_key(s:plugins, name)
			redraw | echo 'removing ' . name
			call system('rm -rf ' . path)
			let removed += [ name ]
		endif
	endfor
	if len(removed) == 0
		redraw | echo 'no plugin needs to be cleaned'
	else
		redraw | echom 'removed ' . len(removed) . ' stale plugins: ' . join(removed, ', ')
	endif
endfunc

func! plug#init()
	com! -nargs=1 Plug call plug#add(<args>)
	com! -nargs=0 PlugInstall call plug#install()
	com! -nargs=0 PlugUpdate call plug#update()
	com! -nargs=0 PlugClean call plug#clean()
endfunc
