" wengwengweng

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
set nolinebreak
set breakindent
set showbreak=..
set nowrapscan
set smartcase
set hidden
set noswapfile
set autoread
set autoindent
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
set scrolloff=3
set signcolumn=yes
set display+=lastline
set diffopt+=iwhite
set laststatus=2
set tabstop=4
set shiftwidth=4
set mouse=a
set formatoptions-=cro
set tags+=./.tags;,.tags
set whichwrap=h,l,<,>
set encoding=utf-8
set termencoding=utf-8
set fileencodings=utf-8,gbk
set guicursor=n-v-c-sm-ci-ve-r-cr-o:block,i:ver25
set wildignore=*/.git/*,*/.svn/*,*/.cache/*,*/.tmp/*,*/node_modules/*
set wildignore=.git,.svn,.cache,.tmp,node_modules
set wildignore+=.DS_Store
set wildignore+=.tags,*.min.*,*.map
set wildignore+=*.zip,*.tar.*,*.app,*.ipa
set wildignore+=*.so,*.o,*.out,*.swp,*.exe,*.elf,*.hex,*.dll,*~
exec 'set listchars=tab:\|\ '
filetype plugin on
filetype indent on
syntax enable
colorscheme super

" plugins
packadd! bookmark
packadd! browser
packadd! comment
packadd! ft
packadd! jump
packadd! line
packadd! music
packadd! pair
packadd! scroll
packadd! search
packadd! space
packadd! theme
packadd! tommywiseau
packadd! trim
packadd! utils

" signify
packadd! signify
let g:signify_vcs_list = [ 'git' ]
let g:signify_sign_show_text = 1
let g:signify_sign_show_count = 0
let g:signify_sign_add = '+'
let g:signify_sign_delete = '-'
let g:signify_sign_delete_first_line = g:signify_sign_delete
let g:signify_sign_change = '~'
let g:signify_sign_changedelete = g:signify_sign_change

" ale
packadd! ale
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '>'
let g:ale_sign_warning = '*'
let g:ale_sign_info = '?'
let g:ale_set_highlights = 0

" tommywiseau
let g:is_human_bean = 0

" unload default plugins
let g:loaded_netrwPlugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_gzip = 1
let g:loaded_rrhelper = 1
let g:loaded_logiPat = 1

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

func! s:hello()

	if !argc()
		Space
	endif

endfunc

augroup Explore

	autocmd!

	autocmd BufEnter *
				\ call s:explore()

augroup END

augroup Hello

	autocmd!

	autocmd VimEnter *
				\ :call s:hello()

augroup END

