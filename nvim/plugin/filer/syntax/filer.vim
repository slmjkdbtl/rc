" wengwengweng

syntax match FilerParent '^..$'
syntax match FilerDirHead '^+' contained
syntax match FilerDir '^+.*' contains=FilerDirHead

highlight def link FilerFile     Normal
highlight def link FilerDir      Title
highlight def link FilerDirHead  Special
highlight def link FilerParent   PreProc

