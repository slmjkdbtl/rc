" wengwengweng

augroup Syntax

	autocmd!

	autocmd BufNewFile,BufRead *.hx
				\ call syntax#set('haxe', '//\ %s')

	autocmd BufNewFile,BufRead *.lua
				\ call syntax#set('lua', '--\ %s')

	autocmd BufNewFile,BufRead *.rs
				\ call syntax#set('rust', '//\ %s')

	autocmd BufNewFile,BufRead *.ck
				\ call syntax#set('chuck', '//\ %s')

	autocmd BufNewFile,BufRead *.fish
				\ call syntax#set('fish', '#\ %s')

	autocmd BufNewFile,BufRead *.ex
				\ call syntax#set('elixir', '#\ %s')

	autocmd BufNewFile,BufRead *.glsl
				\ call syntax#set('glsl', '//\ %s')

	autocmd BufNewFile,BufRead *.scss
				\ call syntax#set('scss', '//\ %s')

	autocmd BufNewFile,BufRead *.toml
				\ call syntax#set('toml', '#\ %s')

	autocmd BufNewFile,BufRead *.{scpt,applescript}
				\ call syntax#set('applescript', '--\ %s')

	autocmd BufNewFile,BufRead *.{md,markdown}
				\ call syntax#set('markdown', '%s')

	autocmd BufNewFile,BufRead */nginx/*.conf
				\ call syntax#set('nginx', '#\ %s')

augroup END

