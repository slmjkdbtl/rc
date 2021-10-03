let s:plugdir = fnamemodify($MYVIMRC, ':h') . '/pack/ext/start'
let s:plugins = {}

func! plug#add(repo)
	let name = split(a:repo, '/')[-1]
	let s:plugins[name] = a:repo
endfunc

func! plug#install()
	for name in keys(s:plugins)
		let dir = s:plugdir . '/' . name
		if !isdirectory(dir)
			echo 'installing ' . name
			call mkdir(s:plugdir, 'p')
			call system('git clone ' . 'https://github.com/' . s:plugins[name] . ' ' . dir)
			redraw
		endif
	endfor
	echo 'done'
endfunc

func! plug#update()
	echo 'checking for updates...'
	for name in keys(s:plugins)
		let dir = s:plugdir . '/' . name
		if isdirectory(dir)
			call system('cd ' . dir . ' && git fetch')
			let cur = system('cd ' . dir . ' && git rev-parse HEAD ')
			let remote = system('cd ' . dir . ' && git rev-parse @{u} ')
			if cur !=# remote
				echo 'updating ' . name
				call system('cd ' . dir . ' && git pull')
			endif
			redraw
		endif
	endfor
	echo 'done'
endfunc

func! plug#clean()
	let entries = glob(s:plugdir . '/*', 0, 1)
	for path in entries
		let name = split(path, '/')[-1]
		if !has_key(s:plugins, name)
			echo 'removing ' . name
			call system('rm -rf ' . path)
			redraw
		endif
	endfor
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
