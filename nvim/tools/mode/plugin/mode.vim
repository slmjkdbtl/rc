" wengwengweng

call mode#add(
			\ 'spell',
			\ {-> execute('setlocal spell')},
			\ {-> execute('setlocal nospell')}
			\ )

call mode#add(
			\ 'expandtab',
			\ {-> execute('setlocal expandtab')},
			\ {-> execute('setlocal noexpandtab')}
			\ )

call mode#add(
			\ 'comment',
			\ {-> execute('setlocal formatoptions+=ro')},
			\ {-> execute('setlocal formatoptions-=ro')}
			\ )

call mode#add(
			\ 'paste',
			\ {-> execute('setlocal paste')},
			\ {-> execute('setlocal nopaste')}
			\ )

call mode#add(
			\ 'number',
			\ {-> execute('setlocal number')},
			\ {-> execute('setlocal nonumber')}
			\ )

call mode#add(
			\ 'wrap',
			\ {-> execute('setlocal wrap')},
			\ {-> execute('setlocal nowrap')}
			\ )

command! -nargs=1 ModeToggle
			\ call mode#toggle(<q-args>)

command! -nargs=1 ModeOn
			\ call mode#on(<q-args>)

command! -nargs=1 ModeOff
			\ call mode#off(<q-args>)

