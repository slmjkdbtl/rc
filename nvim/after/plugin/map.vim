" wengwengweng

" unmap
mapclear
map <tab> <nop>
map <space> <nop>
map <return> <nop>
map <backspace> <nop>

let keys = split('qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM`~!@#$%^&*()-=_+[]{}\;<>?/', '.\zs')

for k in keys

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
noremap <silent> c :redraw!<cr>
noremap <silent> <esc> <esc>:noh<cr>
inoremap <silent> <esc> <esc>
tnoremap <esc> <c-\><c-n>

" movement
noremap k gk
noremap j gj
noremap <up> gk
noremap <down> gj
noremap h h
noremap l l
noremap <m-h> b
noremap <m-l> e
inoremap <m-j> <c-o>gj
inoremap <m-k> <c-o>gk
inoremap <m-h> <left>
inoremap <m-l> <right>
inoremap <up> <c-x><c-y>
inoremap <down> <c-x><c-e>

" buffer
nnoremap <silent> ` <c-^>
nnoremap <silent> - :silent! bprev<cr>
nnoremap <silent> = :silent! bnext<cr>

" edit
nnoremap > A
nnoremap < I
vnoremap > <esc>`>a
vnoremap < <esc>`<i
nnoremap <return> a
nnoremap <m-return> A<return>yo<bs><bs><esc>
vnoremap <return> s
inoremap <m-bs> <c-w>
inoremap <tab> <tab>
inoremap <return> <return>yo<bs><bs>
inoremap <m-return> <esc>mqa<return><esc>`qa<return>
inoremap <m-space> <esc>mqa<space><esc>`qa<space>
cnoremap <m-bs> <c-w>

" undo & redo
nnoremap <silent> u u
nnoremap <silent> o <c-r>
inoremap <silent> <m-u> <c-o>u
inoremap <silent> <m-o> <c-o><c-r>

" cut & copy & paste
noremap <silent> p "*p
nnoremap <silent> y "*yy
vnoremap <silent> y mq"*y`>`q
nnoremap <silent> x "*dd
vnoremap <silent> x "*d
noremap <silent> d "_dd<esc>
inoremap <silent> <m-p> <esc>"*pa

" selection
nnoremap v v
nnoremap <m-v> <c-v>
nnoremap <space> viw
vnoremap <space> <esc>
noremap <m-a> ggVG

" indent
vnoremap <tab> >
vnoremap <m-tab> <

" yo
for i in range(1, 9)
	exec 'noremap <f' . i . '> :echo "y' . repeat('o', i) . '"<cr>'
	exec 'inoremap <f' . i . '> <nop>'
endfor

" plugins
call pair#bind()
call search#bind()
noremap <silent> <m-k> :Scroll -12<cr>
noremap <silent> <m-j> :Scroll 12<cr>
nnoremap <silent> <tab> :Browser<cr>
nnoremap <silent> <m-f> :CtrlP<cr>
nnoremap <silent> <m-t> :CtrlPTag<cr>
nnoremap <silent> <m-b> :CtrlPBuffer<cr>
nnoremap <silent> <m--> :OpenTerm<cr>
nnoremap <silent> <m-=> :OpenFinder<cr>
noremap <silent> / :Comment<cr>
nnoremap <silent> <m-w> :Close<cr>
nnoremap <silent> <m-[> :PrevMark<cr>
nnoremap <silent> <m-]> :NextMark<cr>
nnoremap <silent> w :Write<cr>
nnoremap m :Make<space>
nnoremap z :Projekt<space>

