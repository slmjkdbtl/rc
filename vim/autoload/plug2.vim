let s:basedir = fnamemodify($MYVIMRC, ':h')
let s:extdir = 'ext'
let s:plugins = {}

func! plug#load(path)
	exec 'set runtimepath+=' . s:basedir . '/' . a:path
endfunc

func! plug#loadext(repo)
	let name = split(a:repo, '/')[-1]
	let s:plugins[name] = a:repo
	call plug#load(s:extdir . '/' . name)
endfunc

func! plug#install()
	for name in keys(s:plugins)
		let url = s:plugins[name]
		let dir = s:extdir . '/' . name
		if isdirectory(dir)
			echo 'updating ' . name
			call system('cd ' . dir . ' && git pull')
			redraw
		else
			echo 'installing ' . name
			call system('git clone ' . url . ' ' . dir)
			redraw
		endif
	endfor
	echo 'done'
endfunc
