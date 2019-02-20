" wengwengweng

func! unmap#clear()

	mapclear
	imapclear
	cmapclear
	tmapclear

endfunc

func! unmap#disable_defaults()

	map <tab> <nop>
	map <space> <nop>
	map <return> <nop>
	map <backspace> <nop>

	for k in split('qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM`~!@#$%^&*()-=_+[]{}\;<>?/', '.\zs')

		exec 'map ' . k . ' <nop>'
		exec 'map <m-' . k . '> <nop>'
		exec 'map <c-' . k . '> <nop>'
		exec 'imap <m-' . k . '> <nop>'
		exec 'imap <c-' . k . '> <nop>'

	endfor

	for i in range(1, 9)

		exec 'map <c-' . i . '> <nop>'
		exec 'map <f' . i . '> <nop>'

	endfor

	for i in range(1, 12)
		exec 'noremap <f' . i . '> <nop>'
		exec 'inoremap <f' . i . '> <nop>'
	endfor

endfunc

