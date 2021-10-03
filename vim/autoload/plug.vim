let s:plugdir = fnamemodify($MYVIMRC, ':h') . '/pack/ext/start'
let s:plugins = {}

func! plug#add(repo)
	let name = split(a:repo, '/')[-1]
	let s:plugins[name] = a:repo
endfunc

func! plug#install()
	redraw | echo 'checking for plugins to install...'
	let l:count = 0
	for name in keys(s:plugins)
		let dir = s:plugdir . '/' . name
		if !isdirectory(dir)
			redraw | echom 'installing ' . name
			call mkdir(s:plugdir, 'p')
			call system('git clone ' . 'https://github.com/' . s:plugins[name] . ' ' . dir)
			let l:count += 1
		endif
	endfor
	if l:count == 0
		redraw | echo 'all packages installed'
	else
		redraw | echo 'installed ' . l:count . ' plugins'
	endif
endfunc

func! plug#update()
	redraw | echo 'checking for updates...'
	let l:count = 0
	for name in keys(s:plugins)
		let dir = s:plugdir . '/' . name
		if isdirectory(dir)
			call system('cd ' . dir . ' && git fetch')
			let cur = system('cd ' . dir . ' && git rev-parse HEAD ')
			let remote = system('cd ' . dir . ' && git rev-parse @{u} ')
			if cur !=# remote
				redraw | echom 'updating ' . name
				call system('cd ' . dir . ' && git pull')
				let l:count += 1
			endif
		endif
	endfor
	if l:count == 0
		redraw | echo 'all plugins up to date'
	else
		redraw | echo 'updated ' . l:count . ' plugins'
	endif
endfunc

func! plug#clean()
	redraw | echo 'checking for unused plugins...'
	let l:count = 0
	let entries = glob(s:plugdir . '/*', 0, 1)
	for path in entries
		let name = split(path, '/')[-1]
		if !has_key(s:plugins, name)
			redraw | echom 'removing ' . name
			call system('rm -rf ' . path)
			let l:count += 1
		endif
	endfor
	if l:count == 0
		redraw | echo 'no plugin needs to be removed'
	else
		redraw | echo 'removed ' . l:count . ' stale plugins'
	endif
endfunc

func! plug#init()
	command! -nargs=1 Plug
		\ call plug#add(<args>)
	command! -nargs=0 PlugInstall
		\ call plug#install()
	command! -nargs=0 PlugUpdate
		\ call plug#update()
	command! -nargs=0 PlugClean
		\ call plug#clean()
endfunc
