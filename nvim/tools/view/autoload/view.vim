" wengwengweng

func! view#new()

	enew
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nobuflisted
	setlocal nomodifiable
	setlocal nomodified
	let b:listings = []

endfunc

func! view#update(list)

	let b:listings = a:list

	setlocal modifiable
	silent! 1,$d

	for i in range(len(a:list))
		call append(i, a:list[i])
	endfor

	silent! $,$d
	setlocal nomodifiable
	setlocal nomodified

endfunc

func! view#line_num()
	return line(.)
endfunc

func! view#to(n)
	exec ':' . (a:n)
endfunc

