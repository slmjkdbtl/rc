" wengwengweng

let g:marks = get(g:, 'marks', {})

" call mark#set('lua', [ 'function\s.\+(.*)', 'function(.*)' ])
" call mark#set('cpp', [ '\w\+\s.\+(.*)\s{', 'struct\s\w\+\s{', 'class\s\w\+\s{', 'enum\s\w\+\s{' ])
" call mark#set('c', [ '\w\+\s.\+(.*)\s{', 'struct\s\w\+\s{', 'class\s\w\+\s{', 'enum\s\w\+\s{' ])
" call mark#set('rust', [ 'fn\s.\+(.*)', 'struct\s.\+', 'impl\s.\+', 'enum\s.\+', ])
" call mark#set('javascript', [ '\w\+(\w*)\s{', ])
" call mark#set('vim', [ 'fu\%[nction]\s.\+(.*)', ])
" call mark#set('make', [ '^[^.]\w\+:', ])
" call mark#set('markdown', [ '^#\%[#####]', ])
" call mark#set('css', [ '\S*\s{', ])
" call mark#set('scss', [ '\S*\s{', ])
" call mark#set('pug', [ '\w*(.*)', ])
" call mark#set('nroff', [ '^\.\S', ])

call mark#set('lua', {
	\ 'function': [ 'function\s\zs.\+\ze(.*)', '\zsfunction(.*)\ze' ],
\ })

command! MarkToggle
			\ call mark#toggle()

command! PrevMark
			\ call mark#jump_prev()

command! NextMark
			\ call mark#jump_next()

