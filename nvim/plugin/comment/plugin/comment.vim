" wengwengweng

let g:commentleads = get(g:, 'commentleads', {})

call comment#set([
			\ 'lua',
			\ 'elm',
			\ 'haskell',
			\ 'applescript',
			\ ], '--')

call comment#set([
			\ 'vim',
			\ ], '"')

call comment#set([
			\ 'c',
			\ 'cpp',
			\ 'glsl',
			\ 'go',
			\ 'javascript',
			\ 'java',
			\ 'haxe',
			\ 'rust',
			\ 'scss',
			\ ], '\/\/')


call comment#set([
			\ 'sh',
			\ 'fish',
			\ 'ruby',
			\ 'python',
			\ 'make',
			\ 'elixir',
			\ 'conf',
			\ 'cfg',
			\ ], '#')

call comment#set([
			\ 'lisp',
			\ ], ';;')

call comment#set([
			\ 'erlang',
			\ ], '%')

call comment#set([
			\ 'pug',
			\ ], '\/\/-')

augroup commentleads

	autocmd!

	for [ key, val ] in items(g:commentleads)
		exec "autocmd FileType " . key . " let b:commentlead = '" . val . "'"
	endfor

augroup END

command! -range Comment :<line1>,<line2>call comment#toggle()

