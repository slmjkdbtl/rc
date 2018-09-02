" wengwengweng

set background=dark
hi clear
syntax reset

let g:colors_name = 'super'

let s:italic = ''
let s:bold = 'bold'
let s:base00 = [ '#282f3b', '235' ]
let s:base01 = [ '#343d46', '237' ]
let s:base02 = [ '#4f5b66', '240' ]
let s:base03 = [ '#65737e', '243' ]
let s:base04 = [ '#a7adba', '145' ]
let s:base05 = [ '#c0c5ce', '251' ]
let s:base06 = [ '#cdd3de', '252' ]
let s:base07 = [ '#d8dee9', '253' ]
let s:base08 = [ '#ec5f67', '203' ]
let s:base09 = [ '#f99157', '209' ]
let s:base0A = [ '#fac863', '221' ]
let s:base0B = [ '#99c794', '114' ]
let s:base0C = [ '#62b3b2', '73' ]
let s:base0D = [ '#6699cc', '68' ]
let s:base0E = [ '#c594c5', '176' ]
let s:base0F = [ '#ab7967', '137' ]
let s:base10 = [ '#ffffff', '15' ]
let s:none = [ 'NONE', 'NONE' ]

func! s:hi(group, fg, bg, attr, attrsp)

	if !empty(a:fg)

		exec 'hi ' . a:group . ' guifg=' .  a:fg[0]
		exec 'hi ' . a:group . ' ctermfg=' . a:fg[1]

	endif

	if !empty(a:bg)

		exec 'hi ' . a:group . ' guibg=' .  a:bg[0]
		exec 'hi ' . a:group . ' ctermbg=' . a:bg[1]

	endif

	if !empty(a:attr)

		exec 'hi ' . a:group . ' gui=' .   a:attr
		exec 'hi ' . a:group . ' cterm=' . a:attr

	endif

	if !empty(a:attrsp)

		exec 'hi ' . a:group . ' guisp=' . a:attrsp[0]

	endif

endfunc

call s:hi('Bold',                       '',       '',       s:bold,      '')
call s:hi('Debug',                      s:base08, '',       '',          '')
call s:hi('Directory',                  s:base0D, '',       '',          '')
call s:hi('Error',                      s:base10, s:base08, '',          '')
call s:hi('ErrorMsg',                   s:base08, s:base00, '',          '')
call s:hi('Exception',                  s:base08, '',       '',          '')
call s:hi('FoldColumn',                 s:base0D, s:base00, '',          '')
call s:hi('Folded',                     s:base03, s:base01, s:italic,    '')
call s:hi('IncSearch',                  s:base01, s:base09, '',          '')
call s:hi('Italic',                     '',       '',       s:italic,    '')
call s:hi('Macro',                      s:base08, '',       '',          '')
call s:hi('MatchParen',                 s:base05, s:base03, '',          '')
call s:hi('ModeMsg',                    s:base0B, '',       '',          '')
call s:hi('MoreMsg',                    s:base0B, '',       '',          '')
call s:hi('Question',                   s:base0D, '',       '',          '')
call s:hi('Search',                     s:base03, s:base0A, '',          '')
call s:hi('SpecialKey',                 s:base03, '',       '',          '')
call s:hi('TooLong',                    s:base08, '',       '',          '')
call s:hi('Underlined',                 s:base08, '',       '',          '')
call s:hi('Visual',                     '',       s:base02, '',          '')
call s:hi('VisualNOS',                  s:base08, '',       '',          '')
call s:hi('WarningMsg',                 s:base08, '',       '',          '')
call s:hi('WildMenu',                   s:base10, s:base0D, s:bold,      '')
call s:hi('Title',                      s:base0D, '',       '',          '')
call s:hi('Conceal',                    s:base0D, s:base00, '',          '')
call s:hi('Cursor',                     s:base00, s:base05, '',          '')
call s:hi('NonText',                    s:base03, '',       '',          '')
call s:hi('Normal',                     s:base05, s:base00, '',          '')
call s:hi('EndOfBuffer',                s:base05, s:base00, '',          '')
call s:hi('LineNr',                     s:base03, s:base00, '',          '')
call s:hi('SignColumn',                 s:base00, s:base00, '',          '')
call s:hi('StatusLine',                 s:base01, s:base03, '',          '')
call s:hi('StatusLineNC',               s:base03, s:base01, '',          '')
call s:hi('VertSplit',                  s:base00, s:base02, '',          '')
call s:hi('ColorColumn',                '',       s:base01, '',          '')
call s:hi('CursorColumn',               '',       s:base01, '',          '')
call s:hi('CursorLine',                 '',       s:base01, s:bold,      '')
call s:hi('CursorLineNr',               s:base03, s:base01, s:bold,          '')
call s:hi('PMenu',                      s:base04, s:base01, '',          '')
call s:hi('PMenuSel',                   s:base10, s:base0D, '',          '')
call s:hi('PmenuSbar',                  '',       s:base02, '',          '')
call s:hi('PmenuThumb',                 '',       s:base07, '',          '')
call s:hi('TabLine',                    s:base02, s:base00, 'none',      '')
call s:hi('TabLineFill',                s:base00, s:base00, '',          '')
call s:hi('TabLineSel',                 s:base0B, s:base00, s:bold,      '')
call s:hi('helpExample',                s:base0A, '',       '',          '')
call s:hi('helpCommand',                s:base0A, '',       '',          '')

call s:hi('Boolean',                    s:base09, '',       '',          '')
call s:hi('Character',                  s:base08, '',       '',          '')
call s:hi('Comment',                    s:base03, '',       s:italic,    '')
call s:hi('Conditional',                s:base0E, '',       '',          '')
call s:hi('Constant',                   s:base09, '',       '',          '')
call s:hi('Define',                     s:base0E, '',       '',          '')
call s:hi('Delimiter',                  s:base0F, '',       '',          '')
call s:hi('Float',                      s:base09, '',       '',          '')
call s:hi('Function',                   s:base0D, '',       '',          '')
call s:hi('Identifier',                 s:base08, '',       '',          '')
call s:hi('Include',                    s:base0D, '',       '',          '')
call s:hi('Keyword',                    s:base0E, '',       '',          '')
call s:hi('Label',                      s:base0A, '',       '',          '')
call s:hi('Number',                     s:base09, '',       '',          '')
call s:hi('Operator',                   s:base05, '',       '',          '')
call s:hi('PreProc',                    s:base0A, '',       '',          '')
call s:hi('Repeat',                     s:base0A, '',       '',          '')
call s:hi('Special',                    s:base0C, '',       '',          '')
call s:hi('SpecialChar',                s:base0F, '',       '',          '')
call s:hi('Statement',                  s:base08, '',       '',          '')
call s:hi('StorageClass',               s:base0A, '',       '',          '')
call s:hi('String',                     s:base0B, '',       '',          '')
call s:hi('Structure',                  s:base0E, '',       '',          '')
call s:hi('Tag',                        s:base0A, '',       '',          '')
call s:hi('Todo',                       s:base0A, s:base01, '',          '')
call s:hi('Type',                       s:base0A, '',       '',          '')
call s:hi('Typedef',                    s:base0A, '',       '',          '')

call s:hi('SpellBad',                   '',       '',       'none',      '')
call s:hi('SpellLocal',                 '',       '',       'none',      '')
call s:hi('SpellCap',                   '',       '',       'none',      '')
call s:hi('SpellRare',                  '',       '',       'none',      '')

call s:hi('cssColor',                   s:base0C, '',       '',          '')
call s:hi('cssBraces',                  s:base05, '',       '',          '')
call s:hi('cssClassName',               s:base0E, '',       '',          '')

call s:hi('DiffAdd',                    s:base0B, s:base00, '',          '')
call s:hi('DiffChange',                 s:base02, s:base00, '',          '')
call s:hi('DiffDelete',                 s:base08, s:base00, '',          '')
call s:hi('DiffText',                   s:base0D, s:base00, '',          '')
call s:hi('DiffAdded',                  s:base10, s:base0B, '',          '')
call s:hi('DiffFile',                   s:base08, s:base00, '',          '')
call s:hi('DiffNewFile',                s:base0B, s:base00, '',          '')
call s:hi('DiffLine',                   s:base0D, s:base00, '',          '')
call s:hi('DiffRemoved',                s:base10, s:base08, '',          '')

call s:hi('gitCommitOverflow',          s:base08, '',       '',          '')
call s:hi('gitCommitSummary',           s:base0B, '',       '',          '')

call s:hi('htmlBold',                   s:base0A, '',       '',          '')
call s:hi('htmlItalic',                 s:base0E, '',       '',          '')
call s:hi('htmlTag',                    s:base0C, '',       '',          '')
call s:hi('htmlEndTag',                 s:base0C, '',       '',          '')
call s:hi('htmlArg',                    s:base0A, '',       '',          '')
call s:hi('htmlTagName',                s:base07, '',       '',          '')

call s:hi('javaScript',                 s:base05, '',       '',          '')
call s:hi('javaScriptNumber',           s:base09, '',       '',          '')
call s:hi('javaScriptBraces',           s:base05, '',       '',          '')

call s:hi('markdownCode',               s:base0B, '',       '',          '')
call s:hi('markdownCodeBlock',          s:base0B, '',       '',          '')
call s:hi('markdownHeadingDelimiter',   s:base0D, '',       '',          '')
call s:hi('markdownItalic',             s:base0E, '',       s:italic,    '')
call s:hi('markdownBold',               s:base0A, '',       s:bold,      '')
call s:hi('markdownCodeDelimiter',      s:base0F, '',       s:italic,    '')
call s:hi('markdownError',              s:base05, s:base00, '',          '')

call s:hi('ALEErrorSign',               s:base08, s:base00, '',          '')
call s:hi('ALEWarningSign',             s:base0A, s:base00, '',          '')
call s:hi('ALEInfoSign',                s:base10, s:base00, '',          '')

call s:hi('vimUserFunc',                '',       s:none,   '',          '')
call s:hi('vimFunc',                    '',       s:none,   '',          '')

call s:hi('sassidChar',                 s:base08, '',       '',          '')
call s:hi('sassClassChar',              s:base09, '',       '',          '')
call s:hi('sassInclude',                s:base0E, '',       '',          '')
call s:hi('sassMixing',                 s:base0E, '',       '',          '')
call s:hi('sassMixinName',              s:base0D, '',       '',          '')

hi! vimUserFunc
			\ guibg=none
hi! StatusModeNormal
			\ guibg=#7FA5A5 gui=bold
hi! StatusModeVisual
			\ guibg=#7FA37F gui=bold
hi! StatusModeInsert
			\ guibg=#CB9B9C gui=bold
hi! StatusModeCommand
			\ guibg=#908cab gui=bold
hi! StatusModeTerminal
			\ guibg=#7FA5A5 gui=bold
