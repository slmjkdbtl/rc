func! utils#init()
	com! -nargs=1 Rename        call utils#rename(<f-args>)
	com! -nargs=0 Trash         call utils#trash()
	com! -nargs=1 Retab         call utils#retab(<f-args>)
	com! -nargs=1 GShow         call utils#gshow(<f-args>)
	com! -nargs=0 Preview       call utils#preview()
	com! -nargs=0 OpenWezTerm   call utils#open_wezterm()
	com! -nargs=0 OpenFinder    call utils#open_finder()
	com! -nargs=0 -range Requote <line1>,<line2>call utils#requote()
endfunc

let s:trashdir = get(g:, 'trashdir', '')

if s:trashdir ==# ''
	if has('macunix')
		let s:trashdir = expand('$HOME/.Trash')
	elseif has('unix') || has('win32unix')
		if $XDG_DATA_HOME !=# ''
			let s:trashdir = expand('$XDG_DATA_HOME/Trash')
		else
			let s:trashdir = expand('$HOME/.local/share/Trash')
		endif
	endif
endif

func! utils#rename(newname)

	let path = expand('%:p')
	let name = fnamemodify(path, ':t')
	let dir = fnamemodify(path, ':h')

	if a:newname ==# '' || a:newname =~# '\s' || a:newname ==# name
		echo 'name no good'
		return
	end

	if confirm('rename ' . name . ' to ' . a:newname . '?' , "&yes\n&no") == 1
		let newpath = dir . '/' . a:newname
		bw
		call system('mv ' . path . ' ' . newpath)
		exec 'e ' . newpath
	endif

endfunc

func! utils#trash()

	let path = expand('%:p')
	let name = fnamemodify(path, ':t')

	if s:trashdir ==# ''
		echo 'failed to locate trash dir'
		return
	endif

	if !isdirectory(s:trashdir)
		call mkdir(s:trashdir, 'p')
	endif

	if confirm('move ' . name . ' to trash?', "&yes\n&no") == 1
		bw
		call system('mv ' . path . ' ' . s:trashdir)
	endif

endfunc

func! utils#retab(n)
	let orig_ts = &tabstop
	exec 'retab! ' . a:n
	let &tabstop = orig_ts
endfunc

func! utils#requote()
	:s/'/"/ge
endfunc

func! utils#gshow(tag)
	let name = expand('%:t')
	let dir = expand('%:h')
	let tmpfile = tempname()
	let ft = &filetype
	let content = system('cd ' . dir . ' && git show ' . a:tag . ':./' . name . ' > ' . tmpfile)
	exec 'view ' . tmpfile
	exec 'setf ' . ft
	exec 'file ' . name . ' [' . a:tag . ']'
	redraw | echo ''
endfunc

func! utils#preview()
	let file = expand('%:p')
	let tmpfile = tempname() . '.html'
	call system('cmark ' . file . ' > ' . tmpfile)
	call system('open ' . tmpfile)
endfunc

func! utils#tobuf(n)
	let bufs = getbufinfo({ 'buflisted': 1 })
	if a:n < len(bufs)
		exec 'b' . bufs[a:n].bufnr
	endif
endfunc

func! utils#open_finder()
	call system('open .')
endfunc

func! utils#open_wezterm()
	call system('wezterm cli spawn --cwd ' . escape(getcwd(), ' '))
endfunc
