syn keyword dirtyTodo contained TODO FIXME XXX
syn match dirtyComment /--.*$/ contains=dirtyTodo
syn match dirtyComment /\%^#!.*/
syn region dirtyCommentBlock start=/---/ end=/---/ contains=dirtyTodo
syn region dirtyStr start=/"/ end=/"/ skip=/\\"/
syn match dirtyNum /\d\+/
syn match dirtyNum /-\=\d\+\(.\d\+\)\=/
syn match dirtyBool /[TF]/
syn match dirtySym /[@$?|~%]/
syn match dirtySym /:)/
syn match dirtySym /:(/
syn match dirtyOp /[\\=+<>]/
syn match dirtyOp /+=/
syn match dirtyOp /-=/
syn match dirtyOp /@>/
syn match dirtyOp /@^/
syn match dirtyOp /\.\./
syn match dirtyOp /||/
syn match dirtyOp /&&/
syn match dirtyCall /\w\+\(\s*(.*)\)\@=/
syn match dirtyFunc /\(\~\s*\)\@<=\w\+\(\s*(.*)\)\@=/

hi def link dirtyTodo Todo
hi def link dirtySym Statement
hi def link dirtyStr String
hi def link dirtyNum Number
hi def link dirtyBool Number
hi def link dirtyOp Operator
" hi def link dirtyCall PreProc
" hi def link dirtyFunc Function
hi def link dirtyComment Comment
hi def link dirtyCommentBlock Comment
