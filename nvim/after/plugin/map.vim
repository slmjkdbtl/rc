" wengwengweng

" unmap
mapclear
imapclear
cmapclear
tmapclear
map <tab> <nop>
map <space> <nop>
map <return> <nop>
map <backspace> <nop>

for k in split('qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM`~!@#$%^&*()-=_+[]{}\;<>?/', '.\zs')

	exec 'map ' . k . ' <nop>'
	exec 'map <m-' . k . '> <nop>'
	exec 'map <c-' . k . '> <nop>'
	exec 'imap <m-' . k . '> <nop>'
	exec 'imap <c-' . k . '> <nop>'

endfor

for i in range(1, 9)

	exec 'map <c-' . i . '> <nop>'
	exec 'map <f' . i . '> <nop>'

endfor

" global
noremap : :
noremap . .
nnoremap ! :!
noremap <silent> <esc> <esc><cmd>noh<cr>
inoremap <silent> <esc> <esc>
tnoremap <silent> <esc> <c-\><c-n>

" movement
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> <up> gk
noremap <silent> <down> gj
noremap <silent> h h
noremap <silent> l l
noremap <silent> <m-h> b
noremap <silent> <m-l> e
inoremap <silent> <up> <c-x><c-y>
inoremap <silent> <down> <c-x><c-e>
nnoremap <silent> % %

" buffer
nnoremap <silent> ` <c-^>
tnoremap <silent> ` <c-\><c-n><c-^>
nnoremap <silent> - <cmd>silent! bprev<cr>
nnoremap <silent> = <cmd>silent! bnext<cr>
nnoremap <silent> <m-q> <cmd>silent! bprev<cr>
tnoremap <silent> <m-q> <cmd>silent! bprev<cr>
nnoremap <silent> <m-e> <cmd>silent! bnext<cr>
tnoremap <silent> <m-e> <cmd>silent! bnext<cr>

" edit
nnoremap <silent> > A
nnoremap <silent> < I
vnoremap <silent> > <esc>`>a
vnoremap <silent> < <esc>`<i
nnoremap <silent> <return> a
nnoremap <silent> <m-return> A<return>yo<bs><bs><esc>
vnoremap <silent> <return> s
inoremap <silent> <m-bs> <c-w>
inoremap <silent> <tab> <tab>
inoremap <silent> <return> <return>yo<bs><bs>
inoremap <silent> <m-return> <esc>mqa<return><esc>`qa<return>
nnoremap <silent> c ci
cnoremap <m-bs> <c-w>

" undo & redo
nnoremap <silent> u u
nnoremap <silent> o <c-r>

" cut & copy & paste
noremap <silent> p "*P
nnoremap <silent> y "*yy
vnoremap <silent> y mq"*y`>`q
nnoremap <silent> x "*dd
vnoremap <silent> x "*d
noremap <silent> d "_dd<esc>
inoremap <silent> <m-p> <esc>"*pa

" selection
nnoremap <silent> v V
nnoremap <silent> <space> viw
vnoremap <silent> <space> <esc>
vnoremap <silent> v <esc>
nnoremap <silent> <m-v> v

" indent
vnoremap <silent> <tab> >
vnoremap <silent> <bs> <

" misc
noremap <m-t> <c-]>
nnoremap <m-f> :find<space>
nnoremap <silent> w :w<cr>

" yo
for i in range(1, 12)
	exec 'noremap <f' . i . '> <nop>'
	exec 'inoremap <f' . i . '> <nop>'
endfor

" plugins
call pair#bind()
call search#bind()
noremap <silent> <m-k> <cmd>ScrollUp<cr>
noremap <silent> <m-j> <cmd>ScrollDown<cr>
nnoremap <silent> <tab> :Browser<cr>
nnoremap <silent> <m--> :OpenTerm<cr>
nnoremap <silent> <m-=> :OpenFinder<cr>
noremap <silent> / :CommentToggle<cr>
nnoremap <silent> <m-w> :Close<cr>
nnoremap <silent> <m-[> :PrevMark<cr>
nnoremap <silent> <m-]> :NextMark<cr>
nnoremap <silent> <m-n> :ALEPrevious<cr>
nnoremap <silent> <m-m> :ALENext<cr>
nnoremap <silent> <f1> :ModeToggle comment<cr>
nnoremap <silent> <f2> :ModeToggle spell<cr>
nnoremap <silent> <f3> :ModeToggle number<cr>
nnoremap <silent> <f4> :ModeToggle wrap<cr>
nnoremap <silent> <f5> :ModeToggle paste<cr>
nnoremap z :Bookmark<space>
nnoremap m :!just<space>

