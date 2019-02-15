" wengwengweng

func! SpellOn()
	setlocal spell
endfunc

func! SpellOff()
	setlocal nospell
endfunc

func! CommentOn()
	setlocal formatoptions+=ro
endfunc

func! CommentOff()
	setlocal formatoptions-=ro
endfunc

call mode#add('spell', function('SpellOn'), function('SpellOff'))
call mode#add('comment', function('CommentOn'), function('CommentOff'))

