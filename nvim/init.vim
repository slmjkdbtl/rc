" wengwengweng

runtime! init/*.vim

for p in glob(fnamemodify($MYVIMRC, ':h') . '/plugin/*', 0, 1)
	exec 'set rtp^=' . p
endfor
