" wengwengweng

augroup Edit

	autocmd!

	autocmd FileType *
				\ setlocal noexpandtab|
				\ setlocal tabstop=4

	autocmd FileType lua
				\ iabbrev <buffer> function function<space>end<left><left><left><left>|
				\ iabbrev <buffer> do doend<left><left><left>|
				\ iabbrev <buffer> then thenend<left><left><left>

augroup END
