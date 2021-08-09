" wengwengweng

let s:dir = resolve(expand('<sfile>:p:h:h'))

func! utils#rename(name)

	let file = expand('%')
	let name = expand('%:t')
	let dir = expand('%:h')

	if a:name ==# '' || a:name =~# '\s'
		echo 'name no good'
	end

	if confirm('> rename ' . name . ' to ' . a:name . '?' , "&yes\n&no") == 1

		let oldbufname = bufname('%')

		silent! exec 'saveas ' . dir . '/' . a:name
		exec 'bw' . bufnr(oldbufname)
		call delete(file)

	end

endfunc

" TODO: use trash
func! utils#delete()

	let name = expand('%:t')
	let file = expand('%')

	if confirm('> delete ' . name . '?', "&yes\n&no") == 1
		call delete(file)
		bwipe!
	end

endfunc

func! utils#close()

	if &modified
		echo 'cannot close modified buffer'
		return
	endif

	silent! bwipe

endfunc

func! utils#copy(name)

	let file = expand('%')
	let name = expand('%:t')
	let dir = expand('%:h')

	if a:name ==# '' || a:name =~# '\s' || a:name ==# file
		echo 'name no good'
	endif

	if confirm('> copy to ' . a:name . '?' , "&yes\n&no") == 1
		silent! exec 'saveas ' . dir . '/' . a:name
	endif

endfunc

func! utils#mkdir(name)

	if confirm('> create ' . a:name . '?' , "&yes\n&no") == 1
		silent! call mkdir(a:name)
	endif

endfunc

func! utils#clean_buf()

	let n = 0

	for b in getbufinfo()
		if !b.listed
			if !b.changed
				silent! bw b.bufnr
				let n += 1
			endif
		endif
	endfor

	echo 'Cleared ' . n . ' buffers'

endfunc

func! utils#recfind(wd, file)

	if !filereadable(a:wd . '/' . a:file)

		let pd = fnamemodify(a:wd, ':h')

		if pd !=# '.'
			return utils#recfind(pd, a:file)
		endif

	else

		return a:wd

	endif

endfunc

func! utils#make(target)

	let cwd = getcwd()
	let mdir = utils#recfind(cwd, 'Makefile')

	if isdirectory(mdir)
		exec 'lcd ' . mdir
		exec '!make ' . a:target
		exec 'lcd ' . cwd
	endif

endfunc

func! utils#syncheck()

	if !exists('*synstack')
		return
	endif

	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

endfunc

func! utils#openfinder()
	call system('open .')
endfunc

func! utils#openterm()
	call system('open -a iTerm ' . escape(getcwd(), ' '))
endfunc

