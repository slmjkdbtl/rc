" wengwengweng

let g:src_dir = expand('<sfile>:p:h')
exec 'set runtimepath=' . g:src_dir

" local plugins
call plug#load('bookmark')
call plug#load('find')
call plug#load('browser')
call plug#load('todo')
call plug#load('dirt')
call plug#load('comment')
call plug#load('mark')
call plug#load('line')
call plug#load('pair')
call plug#load('scroll')
call plug#load('search')
call plug#load('space')
call plug#load('mode')
call plug#load('trim')
call plug#load('mru')
call plug#load('utils')
call plug#load('tommywiseau')

" external plugins
call plug#remote('w0rp/ale')
call plug#remote('mhinz/vim-signify')
call plug#remote('racer-rust/vim-racer')

" ft
call ft#detect('*.toml', 'toml')
call ft#detect('*.carp', 'carp')
call ft#detect('*.metal', 'c')
call ft#detect('*.ms', 'nroff')
call ft#detect('*.elm', 'elm')
call ft#detect('*.fish', 'fish')
call ft#detect('*.swift', 'swift')
call ft#detect('*.pug', 'pug')
call ft#detect('*.haml', 'haml')
call ft#detect('*.ck', 'chuck')
call ft#detect('*.scd', 'supercollider')
call ft#detect('*.yml', 'yaml')
call ft#detect('*.yaml', 'yaml')
call ft#detect('*.rs', 'rust')
call ft#detect('*.ron', 'rust')
call ft#detect('*.lua', 'lua')
call ft#detect('*.ts', 'typescript')
call ft#detect('*.pl', 'perl')
call ft#detect('*.p6', 'perl6')
call ft#detect('*.proto', 'proto')
call ft#detect('*.capnp', 'capnp')
call ft#detect('*.lisp', 'lisp')
call ft#detect('*.el', 'lisp')
call ft#detect('*.obj', 'obj')
call ft#detect('*.rst', 'rst')
call ft#detect('*.php', 'php')
call ft#detect('*.css', 'css')
call ft#detect('*.sass', 'sass')
call ft#detect('*.scss', 'scss')
call ft#detect('*.less', 'less')
call ft#detect('*.adoc', 'asciidoc')
call ft#detect('*.ml', 'ocaml')
call ft#detect('*.sh', 'sh')
call ft#detect('*.clj', 'clojure')
call ft#detect('*.xml', 'xml')
call ft#detect('*.plist', 'xml')
call ft#detect('*.c', 'c')
call ft#detect('*.h', 'c')
call ft#detect('*.cpp', 'cpp')
call ft#detect('*.cc', 'cpp')
call ft#detect('*.hpp', 'cpp')
call ft#detect('*.m', 'objc')
call ft#detect('*.go', 'go')
call ft#detect('*.tex', 'tex')
call ft#detect('*.cls', 'tex')
call ft#detect('*.vert', 'glsl')
call ft#detect('*.frag', 'glsl')
call ft#detect('*.glsl', 'glsl')
call ft#detect('*.vim', 'vim')
call ft#detect('*.fish', 'fish')
call ft#detect('*.md', 'markdown')
call ft#detect('*.cs', 'cs')
call ft#detect('*.fs', 'fsharp')
call ft#detect('*.swift', 'swift')
call ft#detect('*.hs', 'haskell')
call ft#detect('*.json', 'json')
call ft#detect('*.hx', 'haxe')
call ft#detect('*.hxml', 'hxml')
call ft#detect('*.hss', 'hss')
call ft#detect('*.scala', 'scala')
call ft#detect('*.srt', 'srt')
call ft#detect('*.js', 'javascript')
call ft#detect('*.vue', 'vue')
call ft#detect('*.rb', 'ruby')
call ft#detect('*.html', 'html')
call ft#detect('*.ex', 'elixir')
call ft#detect('*.java', 'java')
call ft#detect('*.kt', 'kotlin')
call ft#detect('*.dart', 'dart')
call ft#detect('*.terminfo', 'terminfo')
call ft#detect('*.conf', 'conf')
call ft#detect('*.txt', 'text')
call ft#detect('*.pest', 'pest')
call ft#detect('*.syn', 'pest')
call ft#detect('.gitignore', 'conf')
call ft#detect('.cfg', 'conf')
call ft#detect('*conf', 'conf')
call ft#detect('*rc', 'conf')
call ft#detect('.tmux.conf', 'tmux')
call ft#detect('*/nginx/*.conf', 'nginx')
call ft#detect('*.ini', 'ini')
call ft#detect('*.service', 'ini')
call ft#detect('*.bat', 'batch')
call ft#detect('Dockerfile', 'docker')
call ft#detect('Vagrantfile', 'ruby')
call ft#detect('Brewfile', 'brew')
call ft#detect('Justfile', 'conf')
call ft#detect('Makefile', 'make')
call ft#detect('Tupfile', 'tup')
call ft#detect('LICENSE', 'license')
call ft#detect('README', 'readme')
call ft#detect('TODO', 'TODO')
call ft#detect('*.dirt', 'dirt')

call ft#comment('rust', '//', ['//!'])
call ft#comment('cs', '//', [])
call ft#comment('c', '//', [])
call ft#comment('cpp', '//', [])
call ft#comment('go', '//', [])
call ft#comment('typescript', '//', [])
call ft#comment('javascript', '//', [])
call ft#comment('sass', '//', [])
call ft#comment('scss', '//', [])
call ft#comment('less', '//', [])
call ft#comment('glsl', '//', [])
call ft#comment('swift', '//', [])
call ft#comment('scala', '//', [])
call ft#comment('java', '//', [])
call ft#comment('kotlin', '//', [])
call ft#comment('dart', '//', [])
call ft#comment('haxe', '//', [])
call ft#comment('pug', '//', [])
call ft#comment('haml', '//', [])
call ft#comment('json', '//', [])
call ft#comment('chuck', '//', [])
call ft#comment('supercollider', '//', [])
call ft#comment('elm', '--', [])
call ft#comment('lua', '--', [])
call ft#comment('haskell', '--', [])
call ft#comment('toml', '#', [])
call ft#comment('fish', '#', [])
call ft#comment('elixir', '#', [])
call ft#comment('ruby', '#', [])
call ft#comment('yaml', '#', ['-'])
call ft#comment('tup', '#', [])
call ft#comment('perl', '#', [])
call ft#comment('perl6', '#', [])
call ft#comment('docker', '#', [])
call ft#comment('sh', '#', [])
call ft#comment('make', '#', [])
call ft#comment('conf', '#', [])
call ft#comment('tmux', '#', [])
call ft#comment('terminfo', '#', [])
call ft#comment('ini', '#', [])
call ft#comment('hxml', '#', [])
call ft#comment('nginx', '#', [])
call ft#comment('clojure', ';', [])
call ft#comment('carp', ';', [])
call ft#comment('lisp', ';', [])
call ft#comment('vim', '\"', [])
call ft#comment('tex', '%', [])
call ft#comment('nroff', "'''", [])

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
set ignorecase
set cursorline
set hlsearch
set showtabline=2
set guioptions+=!
set path+=**
set scroll=1
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
set fileencodings=utf-8,gbk
set guicursor=n-v-c-sm-ci-ve-r-cr-o:block,i:ver25
set wildignore=*/.git/*,*/.svn/*,*/.cache/*,*/.tmp/*,*/node_modules/*,*/.tup/*
set wildignore=.git,.svn,.cache,.tmp,node_modules,.tup
set wildignore+=.DS_Store
set wildignore+=.tags,*.min.*,*.map
set wildignore+=*.so,*.o,*.out,*.swp,*.exe,*.elf,*.hex,*.dll,*~
exec 'set listchars=tab:\|\ '
colorscheme super

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
let g:ale_sign_error = '>'
let g:ale_sign_warning = '*'
let g:ale_sign_info = '?'
let g:ale_set_highlights = 0
let g:ale_rust_cargo_check_examples = 1
let g:ale_rust_cargo_check_tests = 1

let g:ale_linters = {
	\ 'rust': ['cargo', 'rls'],
	\ 'cs': []
\ }

" racer
au FileType rust nmap <m-t> <plug>(rust-def)

" tommywiseau
let g:is_human_bean = 0

augroup Explore

	autocmd!

	autocmd BufEnter *
				\ call s:explore()

	func! s:explore()

		let l:name = expand('%:p')

		if isdirectory(l:name)

			exec 'lcd ' . l:name
			bd
			Browser

		elseif filereadable(l:name)

			exec 'lcd ' . expand('%:p:h')

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

augroup END

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
noremap <silent> <m-t> <c-]>
nnoremap <silent> w :w<cr>
nnoremap * *

" plugins
call pair#bind()
call search#bind()
call mru#start()
noremap <silent> <m-k> <cmd>ScrollUp<cr>
noremap <silent> <m-j> <cmd>ScrollDown<cr>
nnoremap <silent> <tab> :Browser<cr>
nnoremap <silent> <m--> :OpenTerm<cr>
nnoremap <silent> <m-=> :OpenFinder<cr>
noremap <silent> / :CommentToggle<cr>
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
nnoremap z :Bookmark<space>
nnoremap m :!just<space>

