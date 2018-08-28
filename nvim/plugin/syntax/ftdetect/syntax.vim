" wengwengweng

augroup Syntax

	autocmd!

	autocmd BufNewFile,BufRead *.hx
				\ call syntax#load('haxe', '//%s')

	autocmd BufNewFile,BufRead *.lua
				\ call syntax#load('lua', '--%s')

	autocmd BufNewFile,BufRead *.ck
				\ call syntax#load('chuck', '//%s')

augroup END

