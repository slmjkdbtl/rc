" wengwengweng

func! comment#set(ft, lead)

	if type(a:ft) == 3
		for t in a:ft
			let g:commentleads[t] = get(g:commentleads, t, a:lead)
		endfor
	elseif type(a:ft) == 1
		let g:commentleads[a:ft] = get(g:commentleads, a:ft, a:lead)
	endif

endfunc

func! comment#toggle()

" 	silent! exec 's/\<.*\>/' . b:commentlead . ' \0'
	silent! exec 's/\([^ ]\)/' . b:commentlead . ' \1/'
	silent! exec 's/^\( *\)' . b:commentlead . ' \?' . b:commentlead . ' \?/\1/'

endfun
