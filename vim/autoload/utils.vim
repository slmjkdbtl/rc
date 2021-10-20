func! utils#init()
	com! -nargs=1 Rename        call utils#rename(<f-args>)
	com! -nargs=0 Delete        call utils#delete()
	com! -nargs=1 Retab         call utils#retab(<f-args>)
	com! -nargs=1 GShow         call utils#gshow(<f-args>)
	com! -nargs=0 Preview       call utils#preview()
	com! -nargs=0 Trim          call utils#trim()
	com! -nargs=1 Toggle        call utils#toggle(<f-args>)
	com! -nargs=* ToggleVal     call utils#toggleval(<f-args>)
	com! -nargs=0 OpenWezTerm   call utils#open_wezterm()
	com! -nargs=0 OpenFinder    call utils#open_finder()
	com! -nargs=0 -range Requote <line1>,<line2>call utils#requote()
endfunc

func! utils#rename(newname)

	let path = expand('%:p')
	let name = fnamemodify(path, ':t')
	let dir = fnamemodify(path, ':h')

	if a:newname ==# '' || a:newname =~# '\s' || a:newname ==# name
		echo 'name no good'
		return
	end

	if confirm('rename ' . name . ' to ' . a:newname . '?' , "&yes\n&no") != 1
		return
	endif

	let newpath = dir . '/' . a:newname
	bw
	call system('mv ' . path . ' ' . newpath)
	exec 'e ' . newpath

endfunc

func! utils#delete()

	let path = expand('%:p')
	let name = fnamemodify(path, ':t')

	if confirm('delete "' . name . '"?', "&yes\n&no") != 1
		return
	endif

	bw

	if empty(g:trashdir)
		call system('rm ' . path)
	else
		if !isdirectory(g:trashdir)
			call mkdir(g:trashdir, 'p')
		endif
		call system('mv ' . path . ' ' . g:trashdir)
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

func! utils#trim()
	let save = winsaveview()
	%s/\s\+$//e
	call winrestview(save)
endfunc

func! utils#trim_on_save()
	aug Trim
		au!
		au BufWritePre * Trim
	aug END
endfunc

func! utils#toggle(prop)
	exec 'setl inv' . a:prop
	exec 'echo "' . a:prop . '" &' . a:prop
endfunc

func! utils#toggleval(prop, v1, v2)
	let cur = eval('&' . a:prop)
	if cur === a:v2
		exec 'setl ' . a:prop . ' ' . a:v1
	else
		exec 'setl ' . a:prop . ' ' . a:v1
	endif
	exec 'echo "' . a:prop . '" &' . a:prop
endfunc

func! utils#open_finder()
	call system('open .')
endfunc

func! utils#open_wezterm()
	call system('wezterm cli spawn --cwd ' . escape(getcwd(), ' '))
endfunc
