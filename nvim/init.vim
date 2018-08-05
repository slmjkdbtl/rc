" wengwengweng

" plugins
call plug#begin()
Plug 'mhartington/oceanic-next'
Plug 'nightsense/snow'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tbastos/vim-lua'
Plug 'gmoe/vim-faust'
Plug 'tikhomirov/vim-glsl'
Plug 'pangloss/vim-javascript'
Plug 'digitaltoad/vim-pug'
Plug 'elixir-editors/vim-elixir'
Plug 'dag/vim-fish'
Plug 'plasticboy/vim-markdown'
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'
Plug 'ElmCast/elm-vim'
Plug 'jdonaldson/vaxe'
Plug 'mhinz/vim-signify'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'skywind3000/asyncrun.vim'
call plug#end()

" config
set number
set ruler
set noexpandtab
set smarttab
set termguicolors
set noshowmode
set title
set showcmd
set visualbell
set nowrap
set nowrapscan
set showmatch
set smartcase
set hidden
set noswapfile
set autoread
set autoindent
set incsearch
set lazyredraw
set wildmenu
set wildignorecase
set ignorecase
set cursorline
set showtabline=2
set path+=**
set scrolloff=3
set signcolumn=yes
set background=dark
set display+=lastline
set diffopt+=iwhite
set laststatus=2
set tabstop=4
set shiftwidth=4
set mouse=a
set tags+=./.tags;,.tags
set whichwrap=b,h,l,<,>,[,]
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,gbk
set guicursor=n-v-c-sm-ci-ve-r-cr-o-i:block
set shell=/usr/local/bin/fish
set wildignore=*/.git/*,*/.svn/*,*/.cache/*,*/.tmp/*,*/node_modules/*
set wildignore+=.DS_Store
set wildignore+=*.so,*.o,*.out,*.swp,*.zip,*.app,*.exe,*.dll,*~
set wildignore+=*.png,*.jpg,*.gif,*.ico,*.icns,*.ase
set wildignore+=*.mov,*.mp4,*.avi,*.mkv
set wildignore+=*.mp3,*.wav,*.ogg
set wildignore+=.tags,*.min.*,*.map
filetype plugin indent on
syntax enable

exec 'set list lcs=tab:\|\ '

" oceanic
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 0
silent! colorscheme OceanicNext

" vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_force_overwrite_statusline = 0
let g:vimfiler_no_default_key_mappings = 1
let g:vimfiler_ignore_pattern = ['^\.git$', '^\.DS_Store$', '.cache']

" markdown
let g:vim_markdown_folding_disabled = 1

" signify
let g:signify_vcs_list = [ 'git' ]
let g:signify_sign_show_text = 1
let g:signify_sign_show_count = 0
let g:signify_sign_add = '+'
let g:signify_sign_delete = '-'
let g:signify_sign_delete_first_line = g:signify_sign_delete
let g:signify_sign_change = '~'
let g:signify_sign_changedelete = g:signify_sign_change

" ctrlp
if executable('fd')
	let g:ctrlp_user_command = 'fd .'
endif

let g:ctrlp_root_markers = [ '.git', 'main.lua' ]

" tommywiseau
let g:is_human_bean = 0

" projekt
let g:projekt_switch_action = 'Filer'

" unload default plugins
let g:loaded_netrwPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_spellfile_plugin = 1

" alias
command! Filer
	\ silent! VimFilerCurrentDir -buffer-name=browser -auto-cd -simple -parent

" init
func! s:hello()

	if argc() == 0
		Projekt
	end

endfunc

func! s:bye()

	echo "bye~"

endfunc

augroup greet

	autocmd!
	autocmd VimEnter * :call s:hello()
	autocmd VimLeave * :call s:bye()

augroup END

