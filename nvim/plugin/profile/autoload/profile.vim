" wengwengweng

func! s:oceanic()

	colorscheme OceanicNext
	hi! Normal                   guibg=#282f3b
	hi! LineNr                   guibg=none
	hi! WildMenu                 gui=bold
	hi! SignColumn               guibg=none
	hi! EndOfBuffer              guibg=none
	hi! TabLine                  gui=none
	hi! TabLineSel               guibg=none
	hi! CursorLine               gui=bold
	hi! CursorLineNr             guibg=none
	hi! DiffAdd                  guibg=none
	hi! DiffDelete               guibg=none
	hi! DiffChange               guibg=none
	hi! Error                    guibg=#e66a74
	hi! SpellBad                 gui=none guibg=none
	hi! SpellCap                 gui=none guibg=none
	hi! ErrorMsg                 guibg=none
	hi! vimUserFunc              guibg=none
	hi! StatusModeNormal         guibg=#7FA5A5 gui=bold
	hi! StatusModeVisual         guibg=#7FA37F gui=bold
	hi! StatusModeInsert         guibg=#CB9B9C gui=bold
	hi! StatusModeCommand        guibg=#908cab gui=bold
	hi! StatusModeTerminal       guibg=#7FA5A5 gui=bold
	hi! ALEErrorSign             gui=none guibg=none
	hi! ALEWarningSign           gui=none guibg=none
	hi! ALEInfoSign              gui=none guibg=none
	hi! link TabLineFill         TabLine
	hi! link NvimInternalError   Error

endfunc

func! profile#switch(p)

	if a:p ==# 'oceanic'
		call s:oceanic()
	endif

endfunc

