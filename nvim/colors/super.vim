" wengwengweng

set termguicolors
set background=dark
hi clear
syntax reset

let g:colors_name = 'super'

let s:italic  = 'italic'
let s:bold    = 'bold'
let s:bg      = '#000000'
let s:bg2     = '#111111'
let s:bg3     = '#222222'
let s:bg4     = '#333333'
let s:bg5     = '#444444'
let s:bg6     = '#555555'

let s:black   = '#666666'
let s:normal  = '#dadada'
let s:red     = '#ec7580'
let s:orange  = '#f99157'
let s:yellow  = '#ffca72'
let s:green   = '#98d892'
let s:cyan    = '#7ce9df'
let s:blue    = '#8abbff'
let s:magenta = '#f7aad7'

func! s:hi(group, fg, bg, attr)
	if !empty(a:fg)
		exec 'hi ' . a:group . ' guifg=' .  a:fg
	endif
	if !empty(a:bg)
		exec 'hi ' . a:group . ' guibg=' .  a:bg
	endif
	if !empty(a:attr)
		exec 'hi ' . a:group . ' gui=' .   a:attr
	endif
endfunc

call s:hi('Bold',              '',        '',        s:bold,      )
call s:hi('Boolean',           s:orange,  '',        '',          )
call s:hi('Character',         s:orange,  '',        '',          )
call s:hi('ColorColumn',       '',        s:bg2,     '',          )
call s:hi('Comment',           s:black,   '',        '',          )
call s:hi('Conceal',           s:blue,    s:bg,      '',          )
call s:hi('Conditional',       s:magenta, '',        '',          )
call s:hi('Constant',          s:orange,  '',        '',          )
call s:hi('Cursor',            s:bg,      s:normal,  '',          )
call s:hi('CursorColumn',      '',        s:bg2,     '',          )
call s:hi('CursorLine',        '',        s:bg2,     s:bold,      )
call s:hi('CursorLineNr',      s:bg5,     s:bg2,     s:bold,      )
call s:hi('Debug',             s:red,     '',        '',          )
call s:hi('Define',            s:magenta, '',        '',          )
call s:hi('Delimiter',         s:cyan,    '',        '',          )
call s:hi('Directory',         s:blue,    '',        '',          )
call s:hi('DiffAdd',           s:green,   s:bg,      '',          )
call s:hi('DiffChange',        s:bg3,     s:bg,      '',          )
call s:hi('DiffDelete',        s:red,     s:bg,      '',          )
call s:hi('DiffText',          s:blue,    s:bg,      '',          )
call s:hi('Error',             s:normal,  s:red,     '',          )
call s:hi('ErrorMsg',          s:red,     s:bg,      '',          )
call s:hi('Exception',         s:red,     '',        '',          )
call s:hi('Float',             s:orange,  '',        '',          )
call s:hi('FoldColumn',        s:blue,    s:bg,      '',          )
call s:hi('Folded',            s:bg4,     s:bg2,     s:italic,    )
call s:hi('Function',          s:blue,    '',        '',          )
call s:hi('Identifier',        s:normal,  '',        '',          )
call s:hi('Ignore',            s:normal,  '',        '',          )
call s:hi('IncSearch',         s:bg,      s:orange,  '',          )
call s:hi('Include',           s:blue,    '',        '',          )
call s:hi('Italic',            '',        '',        s:italic,    )
call s:hi('Keyword',           s:magenta, '',        '',          )
call s:hi('Label',             s:yellow,  '',        '',          )
call s:hi('LineNr',            s:bg3,     'none',    '',          )
call s:hi('Macro',             s:red,     '',        '',          )
call s:hi('MatchParen',        s:normal,  s:bg5,     '',          )
call s:hi('ModeMsg',           s:green,   '',        '',          )
call s:hi('MoreMsg',           s:green,   '',        '',          )
call s:hi('NonText',           s:bg3,     '',        '',          )
call s:hi('Normal',            s:normal,  s:bg,      '',          )
call s:hi('Number',            s:orange,  '',        '',          )
call s:hi('Operator',          s:cyan,    '',        '',          )
call s:hi('PreCondit',         s:yellow,  '',        '',          )
call s:hi('PreProc',           s:yellow,  '',        '',          )
call s:hi('Question',          s:blue,    '',        '',          )
call s:hi('Repeat',            s:yellow,  '',        '',          )
call s:hi('Search',            s:bg3,     s:magenta, '',          )
call s:hi('SignColumn',        'none',    s:bg,      '',          )
call s:hi('Special',           s:cyan,    '',        '',          )
call s:hi('SpecialChar',       s:cyan,    '',        '',          )
call s:hi('SpecialComment',    s:cyan,    '',        '',          )
call s:hi('SpecialKey',        s:cyan,    '',        '',          )
call s:hi('SpellBad',          '',        s:bg4,     'none',      )
call s:hi('SpellCap',          '',        '',        'none',      )
call s:hi('SpellLocal',        '',        '',        'none',      )
call s:hi('SpellRare',         '',        '',        'none',      )
call s:hi('Statement',         s:magenta, '',        '',          )
call s:hi('StatusLine',        s:bg2,     s:bg5,     '',          )
call s:hi('StatusLineNC',      s:bg5,     s:bg2,     '',          )
call s:hi('StorageClass',      s:yellow,  '',        '',          )
call s:hi('String',            s:green,   '',        '',          )
call s:hi('Structure',         s:magenta, '',        '',          )
call s:hi('TabLine',           s:bg5,     s:bg,      'none',      )
call s:hi('TabLineFill',       s:bg,      s:bg,      '',          )
call s:hi('TabLineSel',        s:green,   s:bg,      s:bold,      )
call s:hi('Tag',               s:yellow,  '',        '',          )
call s:hi('Title',             s:blue,    '',        '',          )
call s:hi('Todo',              s:yellow,  'none',    '',          )
call s:hi('Type',              s:yellow,  '',        '',          )
call s:hi('Typedef',           s:yellow,  '',        '',          )
call s:hi('Underlined',        s:normal,  '',        '',          )
call s:hi('Union',             s:normal,  '',        '',          )
call s:hi('VertSplit',         s:normal,  '',        '',          )
call s:hi('Visual',            s:bg,      s:yellow,  '',          )
call s:hi('VisualNOS',         s:bg,      s:yellow,  '',          )
call s:hi('WarningMsg',        s:red,     '',        '',          )
call s:hi('WildMenu',          s:normal,  s:blue,    s:bold,      )

call s:hi('StatusModeNormal',  s:normal,  s:bg4,     '',          )
call s:hi('StatusModeVisual',  s:bg,      s:yellow,  '',          )
call s:hi('StatusModeInsert',  s:bg,      s:magenta, '',          )
call s:hi('StatusModeCommand', s:bg,      s:orange,  '',          )
call s:hi('StatusModeTerm',    s:bg,      s:blue,    '',          )

call s:hi('ALEErrorSign',      s:red,     s:bg,      '',          )
call s:hi('ALEWarningSign',    s:yellow,  s:bg,      '',          )
call s:hi('ALEInfoSign',       s:bg5,     s:bg,      '',          )

hi Error NONE
