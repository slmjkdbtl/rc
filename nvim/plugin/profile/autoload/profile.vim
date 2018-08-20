" wengwengweng

func! s:macvim()

	set showmode
	set laststatus=0
	set guifont=Hack:h16
	set nolist
	set signcolumn=no
	set macmeta
	set background=light
	colorscheme macvim
	hi! LineNr guibg=MacTextBackgroundColor

endfunc

func! s:oceanic()

	set noshowmode
	set laststatus=2
	set signcolumn=yes
	set guifont=ProggyCleanTT:h24
	exec 'set list lcs=tab:\|\ '
	set background=dark
	colorscheme OceanicNext
	hi! Normal               guibg=#212d3c
	hi! LineNr               guibg=none
	hi! SignColumn           guibg=none
	hi! EndOfBuffer          guibg=none
	hi! TabLine              gui=none
	hi! TabLineSel           guibg=none
	hi! CursorLineNr         guibg=none
	hi! DiffAdd              guibg=none
	hi! DiffDelete           guibg=none
	hi! DiffChange           guibg=none
	hi! Error                guibg=#e66a74
	hi! StatusModeNormal     guibg=#7FA5A5 gui=bold
	hi! StatusModeVisual     guibg=#7FA37F gui=bold
	hi! StatusModeInsert     guibg=#CB9B9C gui=bold
	hi! StatusModeCommand    guibg=#908cab gui=bold
	hi! StatusModeTerminal   guibg=#7FA5A5 gui=bold
	hi! vimfilerNormalFile   guibg=none
	hi! vimUserFunc          guibg=none
	hi! link TabLineFill TabLine
	hi! link NvimInternalError Error

endfunc

func! profile#switch(p)

	if a:p == 'oceanic'
		call s:oceanic()
	elseif a:p == 'macvim'
		call s:macvim()
	endif

endfunc

