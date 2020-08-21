" wengwengweng

" TODO: syntax highlighting fails after reopening a buffer

" local plugins
call plug#load('proj')
call plug#load('find')
call plug#load('browser')
call plug#load('term')
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
call plug#load('adoc')
call plug#load('pi')
call plug#load('utils')
call plug#load('tommywiseau')

" external plugins
call plug#remote('w0rp/ale')
call plug#remote('mhinz/vim-signify')

" ft
call ft#detect('*.conf', 'conf')
call ft#detect('.cfg', 'conf')
call ft#detect('*conf', 'conf')
call ft#detect('*rc', 'conf')
call ft#detect('*.asm', 'asm')
call ft#detect('*.bf', 'brainfuck')
call ft#detect('*.toml', 'toml')
call ft#detect('*.carp', 'carp')
call ft#detect('*.metal', 'c')
call ft#detect('*.awk', 'awk')
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
call ft#detect('*.ron', 'ron')
call ft#detect('*.lua', 'lua')
call ft#detect('*.ts', 'typescript')
call ft#detect('*.pl', 'perl')
call ft#detect('*.p6', 'perl6')
call ft#detect('*.proto', 'proto')
call ft#detect('*.capnp', 'capnp')
call ft#detect('*.lisp', 'lisp')
call ft#detect('*.el', 'lisp')
call ft#detect('*.ket', 'ketos')
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
call ft#detect('*.zsh', 'zsh')
call ft#detect('.zshrc', 'zsh')
call ft#detect('*.clj', 'clojure')
call ft#detect('*.xml', 'xml')
call ft#detect('*.svg', 'xml')
call ft#detect('*.plist', 'xml')
call ft#detect('*.c', 'c')
call ft#detect('*.h', 'c')
call ft#detect('*.cpp', 'cpp')
call ft#detect('*.cc', 'cpp')
call ft#detect('*.hpp', 'cpp')
call ft#detect('*.m', 'objc')
call ft#detect('*.mm', 'objc')
call ft#detect('*.go', 'go')
call ft#detect('go.mod', 'gomod')
call ft#detect('*.tex', 'tex')
call ft#detect('*.cls', 'tex')
call ft#detect('*.vert', 'glsl')
call ft#detect('*.frag', 'glsl')
call ft#detect('*.glsl', 'glsl')
call ft#detect('*.gql', 'graphql')
call ft#detect('*.graphql', 'graphql')
call ft#detect('*.vim', 'vim')
call ft#detect('vimrc', 'vim')
call ft#detect('*.fish', 'fish')
call ft#detect('*.md', 'markdown')
call ft#detect('*.cs', 'cs')
call ft#detect('*.fs', 'fsharp')
call ft#detect('*.swift', 'swift')
call ft#detect('*.hs', 'haskell')
call ft#detect('*.json', 'json')
call ft#detect('*.gltf', 'json')
call ft#detect('*.ipynb', 'json')
call ft#detect('crontab*', 'crontab')
call ft#detect('*.hx', 'haxe')
call ft#detect('*.hxml', 'hxml')
call ft#detect('*.hss', 'hss')
call ft#detect('*.scala', 'scala')
call ft#detect('*.srt', 'srt')
call ft#detect('*.js', 'javascript')
call ft#detect('*.jsx', 'javascript')
call ft#detect('*.vue', 'vue')
call ft#detect('*.rb', 'ruby')
call ft#detect('*.html', 'html')
call ft#detect('*.ex', 'elixir')
call ft#detect('*.java', 'java')
call ft#detect('*.kt', 'kotlin')
call ft#detect('*.dart', 'dart')
call ft#detect('*.terminfo', 'terminfo')
call ft#detect('*.txt', 'text')
call ft#detect('*.pest', 'pest')
call ft#detect('*.nim', 'nim')
call ft#detect('*.nimble', 'nim')
call ft#detect('*.py', 'python')
call ft#detect('*.scpt', 'applescript')
call ft#detect('*.as', 'actionscript')
call ft#detect('*.shader', 'shaderlab')
call ft#detect('.gitignore', 'conf')
call ft#detect('.tmux.conf', 'tmux')
call ft#detect('*/nginx/*.conf', 'nginx')
call ft#detect('*.ini', 'ini')
call ft#detect('*.service', 'ini')
call ft#detect('.gitconfig', 'ini')
call ft#detect('*.bat', 'batch')
call ft#detect('*.ron', 'ron')
call ft#detect('*.apib', 'apiblueprint')
call ft#detect('[Dd]ockerfile', 'dockerfile')
call ft#detect('[Cc]addyfile', 'caddyfile')
call ft#detect('*/caddy/*.conf', 'caddyfile')
call ft#detect('Vagrantfile', 'ruby')
call ft#detect('Brewfile', 'brew')
call ft#detect('[Jj]ustfile', 'make')
call ft#detect('[Ww]atchfile', 'make')
call ft#detect('Makefile', 'make')
call ft#detect('makefile', 'make')
call ft#detect('Makefile*', 'make')
call ft#detect('*.mk', 'make')
call ft#detect('Tupfile', 'tup')
call ft#detect('*.tup', 'tup')
call ft#detect('LICENSE', 'license')
call ft#detect('README', 'readme')
call ft#detect('*.cmake', 'cmake')
call ft#detect('CMakeLists.txt', 'cmake')
call ft#detect('/etc/hosts', 'conf')

call ft#detect('*.ttx', 'ttx')
call ft#detect('*.dirt', 'dirt')
call ft#detect('TODO', 'TODO')

call ft#comment('rust', '//', ['//!', '///'])
call ft#comment('ron', '//', ['//!'])
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
call ft#comment('objc', '//', [])
call ft#comment('objcpp', '//', [])
call ft#comment('haxe', '//', [])
call ft#comment('actionscript', '//', [])
call ft#comment('shaderlab', '//', [])
call ft#comment('pug', '//', [])
call ft#comment('haml', '//', [])
call ft#comment('json', '//', [])
call ft#comment('chuck', '//', [])
call ft#comment('supercollider', '//', [])
call ft#comment('asciidoc', '//', ['-'])
call ft#comment('ron', '//', [])
call ft#comment('elm', '--', [])
call ft#comment('lua', '--', [])
call ft#comment('haskell', '--', [])
call ft#comment('nim', '#', ['##'])
call ft#comment('toml', '#', [])
call ft#comment('fish', '#', [])
call ft#comment('elixir', '#', [])
call ft#comment('ruby', '#', [])
call ft#comment('yaml', '#', ['-'])
call ft#comment('tup', '#', [])
call ft#comment('perl', '#', [])
call ft#comment('perl6', '#', [])
call ft#comment('dockerfile', '#', [])
call ft#comment('caddyfile', '#', [])
call ft#comment('sh', '#', [])
call ft#comment('zsh', '#', [])
call ft#comment('make', '#', [])
call ft#comment('conf', '#', [])
call ft#comment('tmux', '#', [])
call ft#comment('terminfo', '#', [])
call ft#comment('ini', '#', [])
call ft#comment('hxml', '#', [])
call ft#comment('nginx', '#', [])
call ft#comment('python', '#', [])
call ft#comment('applescript', '#', [])
call ft#comment('clojure', ';', [])
call ft#comment('carp', ';', [])
call ft#comment('lisp', ';', [])
call ft#comment('ketos', ';', [])
call ft#comment('vim', '\"', [])
call ft#comment('tex', '%', [])
call ft#comment('nroff', "'''", [])

call ft#comment('ttx', "--", [])
call ft#comment('dirt', "#", [])
call ft#comment('TODO', "#", ['-'])

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
set fileencodings=utf-8,gbk
set guicursor=n-v-c-sm-ci-ve-r-cr-o:block,i:ver25
set wildignore=*/.git/*,*/.svn/*,*/.cache/*,*/.tmp/*,*/node_modules/*,*/.tup/*
set wildignore=.git,.svn,.cache,.tmp,node_modules,.tup
set wildignore+=.DS_Store
set wildignore+=.tags,*.map
set wildignore+=*.so,*.o,*.out,*.swp,*.exe,*.elf,*.hex,*.dll,*~
exec 'set listchars=tab:\|\ '
colorscheme super

let g:trash_dir = expand('$HOME/.Trash')

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
	\ 'cs': [],
	\ 'c': [],
	\ 'cpp': [],
\ }

" tommywiseau
let g:is_human_bean = 0

" adoc
let g:adoc_theme_file = '$CONF/asciidoc/super/theme.yml'
let g:adoc_font_dir = '$CONF/asciidoc/super/fonts'

augroup Explore

	autocmd!

	autocmd BufEnter *
				\ call s:enter()

	func! s:enter()

		let name = expand('%:p')

		if empty(name)
			if len(getbufinfo({ 'buflisted': 1 })) == 1
				Space
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
call mru#start()
noremap <silent> <m-k> <cmd>ScrollUp<cr>
noremap <silent> <m-j> <cmd>ScrollDown<cr>
nnoremap <silent> <tab> :BrowserToggle<cr>
nnoremap <silent> <m--> :OpenTerm<cr>
nnoremap <silent> <m-=> :OpenFinder<cr>
noremap <silent> / :CommentToggle<cr>
" nnoremap <silent> <m-t> :TermToggle<cr>
tnoremap <silent> <m-t> <c-\><c-n>:TermToggle<cr>
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
nnoremap z :Proj<space>
nnoremap m :!just<space>

