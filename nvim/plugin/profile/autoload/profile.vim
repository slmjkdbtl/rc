" wengwengweng

func! s:macvim()

	set showmode
	set laststatus=0
	set guifont=hack:h16
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
	exec 'set list lcs=tab:\|\ '
	set background=dark
	colorscheme OceanicNext
	hi! vimfilerNormalFile guibg=none
	hi! vimUserFunc guibg=none
	hi! TabLine gui=none
	hi! TabLineSel guibg=none
	hi! Error guibg=#e66a74
	hi! link TabLineFill TabLine
	hi! link NvimInternalError Error
	hi! StatusModeNormal   guibg=#7FA5A5 gui=bold
	hi! StatusModeVisual   guibg=#7FA37F gui=bold
	hi! StatusModeInsert   guibg=#CB9B9C gui=bold
	hi! StatusModeCommand  guibg=#908cab gui=bold
	hi! StatusModeTerminal guibg=#7FA5A5 gui=bold

endfunc

func! profile#switch(p)

	if a:p == 'oceanic'
		call s:oceanic()
	elseif a:p == 'macvim'
		call s:macvim()
	endif

endfunc

