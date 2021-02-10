" wengwengweng

" local plugins
call plug#load('proj')
call plug#load('find')
call plug#load('browser')
call plug#load('comment')
call plug#load('mark')
call plug#load('pair')
call plug#load('scroll')
call plug#load('search')
call plug#load('space')
call plug#load('mode')
call plug#load('trim')
call plug#load('mru')
call plug#load('utils')

" external plugins
call plug#remote('w0rp/ale')
call plug#remote('mhinz/vim-signify')

call ft#detect('Justfile', 'make')
call ft#detect('*.vert', 'glsl')
call ft#detect('*.frag', 'glsl')
call ft#detect('*.toml', 'toml')
call ft#detect('*.graphql', 'graphql')

" options
set magic
set nonumber
set noruler
set noexpandtab
set smarttab
set termguicolors
set noshowmode
set title
set showcmd
set noerrorbells
set novisualbell
set showmatch
set matchtime=0
set wrap
set nospell
set spelllang=en
set nowrapscan
set nolinebreak
set breakindent
set showbreak=..
set commentstring=
set comments=
set smartcase
set hidden
set noswapfile
set autoread
set autoindent
set nosmartindent
set incsearch
set lazyredraw
set wildmenu
set list
set wildignorecase
set nofoldenable
set ignorecase
set cursorline
set hlsearch
set ttimeoutlen=0
set cpoptions=aABceFs
set showtabline=2
set guifont=ProggyCleanTT:h24
set guioptions+=!
set path+=**
set scroll=8
set scrolloff=3
set signcolumn=yes
set display+=lastline
set diffopt+=iwhite
set laststatus=2
set tabstop=4
set shiftwidth=4
set mouse=a
set formatoptions=
set tags+=./.tags;,.tags
set whichwrap=h,l,<,>
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8
set guicursor=n-v-c-sm-ci-ve-r-cr-o:block,i:ver25
set wildignore=*/.git/*,*/.svn/*,*/.cache/*,*/.tmp/*,*/node_modules/*,*/.tup/*
set wildignore=.git,.svn,.cache,.tmp,node_modules,.tup
set wildignore+=.DS_Store
set wildignore+=.tags,*.map
set wildignore+=*.so,*.o,*.out,*.swp,*.exe,*.elf,*.hex,*.dll,*~
exec 'set listchars=tab:\|\ '
colorscheme super

let loaded_netrwPlugin = 1

" signify
let g:signify_vcs_list = [ 'git' ]
let g:signify_sign_show_text = 1
let g:signify_sign_show_count = 0
let g:signify_sign_add = '+'
let g:signify_sign_delete = '-'
let g:signify_sign_delete_first_line = g:signify_sign_delete
let g:signify_sign_change = '~'
let g:signify_sign_changedelete = g:signify_sign_change

" ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_sign_error = '>'
let g:ale_sign_warning = '*'
let g:ale_sign_info = '?'
let g:ale_set_highlights = 0
let g:ale_rust_cargo_check_examples = 1
let g:ale_rust_cargo_check_tests = 1

let g:ale_linters = {
	\ 'cs': [],
	\ 'c': [],
	\ 'cpp': [],
\ }

augroup Explore

	autocmd!

	autocmd BufEnter *
				\ call s:enter()

	func! s:enter()

		let name = expand('%:p')

		if empty(name)
			if len(getbufinfo({ 'buflisted': 1 })) == 1
" 				Space
			endif
		else
			if isdirectory(name)
				exec 'lcd ' . name
				bwipe
				Browser
			elseif filereadable(name)
				exec 'lcd ' . expand('%:p:h')
			endif
		endif

		silent! CleanBuf

	endfunc

augroup END

augroup Hello

	autocmd!

	autocmd VimEnter *
				\ call s:hello()

	func! s:hello()

		if !argc()
			Space
		endif

	endfunc

	autocmd BufEnter *
				\ if &filetype == "" | setl ft=text | endif

augroup END


call mru#start()

" unmap
call unmap#clear()
call unmap#disable_defaults()

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
noremap <silent> % %
noremap <silent> ^ gg
noremap <silent> $ G

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
nnoremap <silent> w :w<cr>
nnoremap * *

" plugins
call pair#bind()
call search#bind()
noremap <silent> <m-k> <cmd>ScrollUp<cr>
noremap <silent> <m-j> <cmd>ScrollDown<cr>
nnoremap <silent> <tab> :BrowserToggle<cr>
nnoremap <silent> <m--> :OpenTerm<cr>
nnoremap <silent> <m-=> :OpenFinder<cr>
noremap <silent> / :CommentToggle<cr>
" nnoremap <silent> <m-t> :TermToggle<cr>
nnoremap <silent> <m-w> :Close<cr>
" nnoremap <silent> <m-[> :PrevMark<cr>
" nnoremap <silent> <m-]> :NextMark<cr>
nnoremap <silent> <m-n> :ALEPrevious<cr>
nnoremap <silent> <m-m> :ALENext<cr>
nnoremap <silent> <f1> :ModeToggle comment<cr>
nnoremap <silent> <f2> :ModeToggle spell<cr>
nnoremap <silent> <f3> :ModeToggle number<cr>
nnoremap <silent> <f4> :ModeToggle wrap<cr>
nnoremap <silent> <f5> :ModeToggle paste<cr>
nnoremap <silent> <f6> :ModeToggle expandtab<cr>
nnoremap <m-f> :Find<cr>
nnoremap <m-g> :Grep<cr>
nnoremap <m-d> :MRU<cr>
nnoremap z :Proj<space>
nnoremap m :!just<space>

