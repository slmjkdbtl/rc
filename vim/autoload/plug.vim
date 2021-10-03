let s:plugdir = fnamemodify($MYVIMRC, ':h') . '/pack/ext/start'
let s:plugins = {}

func! plug#add(repo)
	let name = split(a:repo, '/')[-1]
	let s:plugins[name] = a:repo
endfunc

func! plug#install()
	for name in keys(s:plugins)
		let url = 'https://github.com/' . s:plugins[name]
		let dir = s:plugdir . '/' . name
		if isdirectory(dir)
			echo 'updating ' . name
			call system('cd ' . dir . ' && git pull')
			redraw
		else
			echo 'installing ' . name
			call mkdir(s:plugdir, 'p')
			call system('git clone ' . url . ' ' . dir)
			redraw
		endif
	endfor
	echo 'done'
endfunc

func! plug#init()
	command! -nargs=1 Plug
		\ call plug#add(<args>)
	command! -nargs=0 PlugInstall
		\ call plug#install()
endfunc
