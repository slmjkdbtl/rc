" wengwengweng

func! utils#rename(name)

	let l:file = expand('%')
	let l:name = expand('%:t')
	let l:dir = expand('%:h')

	if a:name == '' || a:name =~ '\s'
		echo 'name no good'
	end

	if confirm('> rename ' . l:name . ' to ' . a:name . '?' , "&yes\n&no") == 1

		silent! exec 'saveas ' . l:dir . '/' . a:name
		call delete(l:file)

	end

endfunc

func! utils#delete()

	let l:name = expand('%:t')
	let l:file = expand('%')

	if confirm('> delete ' . l:name . '?', "&yes\n&no") == 1

		call delete(l:file)
		bdelete!

	end

endfunc

func! utils#close()

	if confirm('> close ' . bufname('%') .'?', "&yes\n&no") == 1
		if bufname('%') == ''
			q
		else
			bd
		endif
	end

endfunc

func! utils#copy(name)

	let l:file = expand('%')
	let l:name = expand('%:t')
	let l:dir = expand('%:h')

	if a:name == '' || a:name =~ '\s' || a:name == l:file
		echo 'name no good'
	endif

	if confirm('> copy to ' . a:name . '?' , "&yes\n&no") == 1
		silent! exec 'saveas ' . l:dir . '/' . a:name
	endif

endfunc

func! utils#mkdir(name)

	if confirm('> create ' . a:name . '?' , "&yes\n&no") == 1
		silent! call mkdir(a:name)
	endif

endfunc

func! utils#cdtcb()

	exec 'lcd ' . expand('%:p:h')
	pwd

endfunc

func! utils#open()

	call system('open .')

endfunc

func! utils#recfind(wd, file)

	if !filereadable(a:wd . '/' . a:file)

		let l:pd = fnamemodify(a:wd, ':h')

		if l:pd != '.'
			return utils#recfind(l:pd, a:file)
		endif

	else

		return a:wd

	endif

endfunc

func! utils#make(target)

	let l:cwd = getcwd()
	let l:mdir = utils#recfind(l:cwd, 'Makefile')

	if isdirectory(l:mdir)

		exec 'lcd ' . l:mdir
		exec '!make ' . a:target
		exec 'lcd ' . l:cwd

	endif

endfunc

func! utils#syncheck()

	if !exists("*synstack")
		return
	endif

	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

endfunc

