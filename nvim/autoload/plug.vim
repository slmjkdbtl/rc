" wengwengweng

let s:dir = expand('~/.local/share/nvim/plug')
let s:plugins = []

func! plug#set_dir(dir)
	let s:dir = a:dir
endfunc

func! plug#load(name)
	exec 'set runtimepath+=' . a:name
endfunc

func! plug#loadall(path)
	for f in glob(a:path . '/*', 0, 1)
		if isdirectory(f)
			call plug#load(f)
		endif
	endfor
endfunc

func! plug#add(name)
	let s:plugins = s:plugins + [a:name]
endfunc

func! plug#setup()
	call plug#loadall(s:dir)
endfunc

func! plug#install()

	for p in s:plugins

		let url = 'https://github.com/' . p . '.git'
		let name = split(p, '/')[1]
		let dir = s:dir . '/' . name

		if !isdirectory(dir)

			echo 'installing ' . name
			call system('git clone ' . url . ' ' . dir)
			redraw

		else

			echo 'updating ' . name
			call system('cd ' . dir . ' && git pull')
			redraw

		endif

	endfor

endfunc

