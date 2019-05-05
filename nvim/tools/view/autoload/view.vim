" wengwengweng

func! view#new()

	enew
	setlocal buftype=nofile
	setlocal bufhidden=wipe
	setlocal nobuflisted
	setlocal nomodifiable
	setlocal nomodified
	let b:view_lines = []

endfunc

func! view#update(lines)

	let b:view_lines = a:lines

	setlocal modifiable
	silent! 1,$d

	for i in range(len(a:lines))
		call append(i, a:lines[i])
	endfor

	silent! $,$d
	setlocal nomodifiable
	setlocal nomodified

endfunc

func! view#to(n)
	exec ':' . (a:n)
endfunc

