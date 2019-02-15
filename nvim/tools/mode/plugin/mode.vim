" wengwengweng

call mode#add(
			\ 'spell',
			\ {-> execute('setlocal spell')},
			\ {-> execute('setlocal nospell')}
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

