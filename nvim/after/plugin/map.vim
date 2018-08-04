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
nnoremap r :!
noremap . .
noremap <silent> <esc> <esc>:noh<cr>
tnoremap <esc> <c-\><c-n>
inoremap <esc> <esc>

" movement
noremap k k
noremap j j
noremap h h
noremap l l
noremap q b
noremap e e
noremap <m-h> ^
noremap <m-l> $
noremap <m-left> b
noremap <m-right> e
inoremap <m-h> <left>
inoremap <m-l> <right>
inoremap <m-j> <down>
inoremap <m-k> <up>
inoremap <m-left> <c-left>
inoremap <m-right> <c-right>

" buffers
noremap ` <c-^>
noremap <silent> - :bp<cr>
noremap <silent> = :bn<cr>

" edit
nnoremap > A
nnoremap < I
vnoremap > <esc>`>a
vnoremap < <esc>`<i
nnoremap <return> a
vnoremap <return> s
inoremap <m-bs> <c-w>
inoremap <tab> <tab>
inoremap <return> <return>yo<backspace><backspace>

" undo & redo
noremap u u
noremap o <c-r>

" cut & copy & paste
noremap <silent> p "*p
nnoremap <silent> y "*yy
vnoremap <silent> y "*y`>
vnoremap <silent> x "*d
noremap <silent> d "_dd<esc>
inoremap <silent> <m-p> <esc>"*pa

" make
nnoremap b :!make<space>

" search
nnoremap ? /
vnoremap <silent> ? y/<c-r>"<cr>N
noremap <silent> n N
noremap <silent> m n
nnoremap <silent> c :noh<esc>cgn

" selection
noremap v v
noremap <m-v> <c-v>
nnoremap <space> viw
vnoremap <space> <esc>
noremap <m-a> ggVG

" indent
vnoremap <tab> >
vnoremap <m-tab> <

" tabs
nnoremap <silent> <m-q> :tabp<cr>
nnoremap <silent> <m-e> :tabn<cr>
nnoremap <silent> <m-n> :tabe<cr>:Projekt<cr>
inoremap <silent> <m-q> <esc>:tabp<cr>
inoremap <silent> <m-e> <esc>:tabn<cr>
inoremap <silent> <m-n> <esc>:tabe<cr>:Projekt<cr>
tnoremap <silent> <m-q> <c-\><c-n>:tabp<cr>
tnoremap <silent> <m-e> <c-\><c-n>:tabn<cr>
tnoremap <silent> <m-n> <c-\><c-n>:tabe<cr>:Projekt<cr>

" yo
for i in range(1, 9)
	exec 'noremap <f' . i . '> :echo "y' . repeat('o', i) . '"<cr>'
endfor

" vimfiler
func! s:vimfiler_remap()

	map <buffer> <return> <Plug>(vimfiler_cd_or_edit)
	map <buffer> <space> <Plug>(vimfiler_expand_tree)
	map <buffer> <tab> <Plug>(vimfiler_close)
	map <buffer> <bs> <Plug>(vimfiler_switch_to_parent_directory)
	map <buffer> 0 <Plug>(vimfiler_switch_to_project_directory)
	map <buffer> j <Plug>(vimfiler_loop_cursor_down)
	map <buffer> k <Plug>(vimfiler_loop_cursor_up)

endfunc

augroup vimfilerremap

	autocmd!
	autocmd FileType vimfiler :call s:vimfiler_remap()

augroup END

" plugins
call pair#bind()
noremap <silent> <m-k> :Scroll -12<cr>
noremap <silent> <m-j> :Scroll 12<cr>
nnoremap <silent> <tab> :Filer<cr>
noremap <silent> <m-f> :CtrlP<cr>
noremap <silent> <m-t> :CtrlPTag<cr>
noremap <silent> <m-b> :CtrlPBuffer<cr>
noremap <silent> <m-o> :NewITermTab<cr>
noremap <silent> / :Comment<cr>
nnoremap <silent> <m-w> :Close<cr>
nnoremap <silent> <m-[> :PrevFunc<cr>
nnoremap <silent> <m-]> :NextFunc<cr>
noremap z :Projekt<space>

