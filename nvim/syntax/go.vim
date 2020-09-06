" Copyright 2009 The Go Authors. All rights reserved.
" Use of this source code is governed by a BSD-style
" license that can be found in the LICENSE file.
"
" go.vim: Vim syntax file for Go.

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn case match

syn keyword     goPackage           package
syn keyword     goImport            import    contained
syn keyword     goVar               var       contained
syn keyword     goConst             const     contained

hi def link     goPackage           Statement
hi def link     goImport            Statement
hi def link     goVar               Keyword
hi def link     goConst             Keyword
hi def link     goDeclaration       Keyword

" Keywords within functions
syn keyword     goStatement         defer go goto return break continue fallthrough
syn keyword     goConditional       if else switch select
syn keyword     goLabel             case default
syn keyword     goRepeat            for range

hi def link     goStatement         Statement
hi def link     goConditional       Conditional
hi def link     goLabel             Label
hi def link     goRepeat            Repeat

" Predefined types
syn keyword     goType              chan map bool string error
syn keyword     goSignedInts        int int8 int16 int32 int64 rune
syn keyword     goUnsignedInts      byte uint uint8 uint16 uint32 uint64 uintptr
syn keyword     goFloats            float32 float64
syn keyword     goComplexes         complex64 complex128

hi def link     goType              Type
hi def link     goSignedInts        Type
hi def link     goUnsignedInts      Type
hi def link     goFloats            Type
hi def link     goComplexes         Type

" Predefined functions and values
syn keyword     goBuiltins                 append cap close complex copy delete imag len
syn keyword     goBuiltins                 make new panic print println real recover
syn keyword     goBoolean                  true false
syn keyword     goPredefinedIdentifiers    nil iota

hi def link     goBuiltins                 Identifier
hi def link     goBoolean                  Boolean
hi def link     goPredefinedIdentifiers    goBoolean

" Comments; their contents
syn keyword     goTodo              contained TODO FIXME XXX BUG
syn cluster     goCommentGroup      contains=goTodo

syn region      goComment           start="//" end="$" contains=goGenerate,@goCommentGroup,@Spell
syn region    goComment           start="/\*" end="\*/" contains=@goCommentGroup,@Spell

hi def link     goComment           Comment
hi def link     goTodo              Todo

" Go escapes
syn match       goEscapeOctal       display contained "\\[0-7]\{3}"
syn match       goEscapeC           display contained +\\[abfnrtv\\'"]+
syn match       goEscapeX           display contained "\\x\x\{2}"
syn match       goEscapeU           display contained "\\u\x\{4}"
syn match       goEscapeBigU        display contained "\\U\x\{8}"
syn match       goEscapeError       display contained +\\[^0-7xuUabfnrtv\\'"]+

hi def link     goEscapeOctal       goSpecialString
hi def link     goEscapeC           goSpecialString
hi def link     goEscapeX           goSpecialString
hi def link     goEscapeU           goSpecialString
hi def link     goEscapeBigU        goSpecialString
hi def link     goSpecialString     Special
hi def link     goEscapeError       Error

" Strings and their contents
syn cluster     goStringGroup       contains=goEscapeOctal,goEscapeC,goEscapeX,goEscapeU,goEscapeBigU,goEscapeError
syn region      goString            start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@goStringGroup
syn region      goRawString         start=+`+ end=+`+

" [n] notation is valid for specifying explicit argument indexes
" 1. Match a literal % not preceded by a %.
" 2. Match any number of -, #, 0, space, or +
" 3. Match * or [n]* or any number or nothing before a .
" 4. Match * or [n]* or any number or nothing after a .
" 5. Match [n] or nothing before a verb
" 6. Match a formatting verb
syn match       goFormatSpecifier   /\
      \%([^%]\%(%%\)*\)\
      \@<=%[-#0 +]*\
      \%(\%(\%(\[\d\+\]\)\=\*\)\|\d\+\)\=\
      \%(\.\%(\%(\%(\[\d\+\]\)\=\*\)\|\d\+\)\=\)\=\
      \%(\[\d\+\]\)\=[vTtbcdoqxXUeEfFgGspw]/ contained containedin=goString,goRawString
hi def link     goFormatSpecifier   goSpecialString

hi def link     goString            String
hi def link     goRawString         String

" Characters; their contents
syn cluster     goCharacterGroup    contains=goEscapeOctal,goEscapeC,goEscapeX,goEscapeU,goEscapeBigU
syn region      goCharacter         start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=@goCharacterGroup

hi def link     goCharacter         Character

" Regions
syn region      goParen             start='(' end=')' transparent
syn region    goBlock             start="{" end="}" transparent

" import
syn region    goImport            start='import (' end=')' transparent contains=goImport,goString,goComment

" var, const
syn region    goVar               start='var ('   end='^\s*)$' transparent
                      \ contains=ALLBUT,goParen,goBlock,goFunction,goTypeName,goReceiverType,goReceiverVar,goParamName,goParamType,goSimpleParams,goPointerOperator
syn region    goConst             start='const (' end='^\s*)$' transparent
                      \ contains=ALLBUT,goParen,goBlock,goFunction,goTypeName,goReceiverType,goReceiverVar,goParamName,goParamType,goSimpleParams,goPointerOperator

" Single-line var, const, and import.
syn match       goSingleDecl        /\%(import\|var\|const\) [^(]\@=/ contains=goImport,goVar,goConst

" Integers
syn match       goDecimalInt        "\<-\=\(0\|[1-9]_\?\(\d\|\d\+_\?\d\+\)*\)\%([Ee][-+]\=\d\+\)\=\>"
syn match       goDecimalError      "\<-\=\(_\(\d\+_*\)\+\|\([1-9]\d*_*\)\+__\(\d\+_*\)\+\|\([1-9]\d*_*\)\+_\+\)\%([Ee][-+]\=\d\+\)\=\>"
syn match       goHexadecimalInt    "\<-\=0[xX]_\?\(\x\+_\?\)\+\>"
syn match       goHexadecimalError  "\<-\=0[xX]_\?\(\x\+_\?\)*\(\([^ \t0-9A-Fa-f_]\|__\)\S*\|_\)\>"
syn match       goOctalInt          "\<-\=0[oO]\?_\?\(\o\+_\?\)\+\>"
syn match       goOctalError        "\<-\=0[0-7oO_]*\(\([^ \t0-7oOxX_/)\]\}\:]\|[oO]\{2,\}\|__\)\S*\|_\|[oOxX]\)\>"
syn match       goBinaryInt         "\<-\=0[bB]_\?\([01]\+_\?\)\+\>"
syn match       goBinaryError       "\<-\=0[bB]_\?[01_]*\([^ \t01_]\S*\|__\S*\|_\)\>"

hi def link     goDecimalInt        Integer
hi def link     goDecimalError      Error
hi def link     goHexadecimalInt    Integer
hi def link     goHexadecimalError  Error
hi def link     goOctalInt          Integer
hi def link     goOctalError        Error
hi def link     goBinaryInt         Integer
hi def link     goBinaryError       Error
hi def link     Integer             Number

" Floating point
syn match       goFloat             "\<-\=\d\+\.\d*\%([Ee][-+]\=\d\+\)\=\>"
syn match       goFloat             "\<-\=\.\d\+\%([Ee][-+]\=\d\+\)\=\>"

hi def link     goFloat             Float

" Imaginary literals
syn match       goImaginary         "\<-\=\d\+i\>"
syn match       goImaginary         "\<-\=\d\+[Ee][-+]\=\d\+i\>"
syn match       goImaginaryFloat    "\<-\=\d\+\.\d*\%([Ee][-+]\=\d\+\)\=i\>"
syn match       goImaginaryFloat    "\<-\=\.\d\+\%([Ee][-+]\=\d\+\)\=i\>"

hi def link     goImaginary         Number
hi def link     goImaginaryFloat    Float

" Extra types commonly seen
" syn match goExtraType /\<bytes\.\%(Buffer\)\>/
" syn match goExtraType /\<context\.\%(Context\)\>/
" syn match goExtraType /\<io\.\%(Reader\|ReadSeeker\|ReadWriter\|ReadCloser\|ReadWriteCloser\|Writer\|WriteCloser\|Seeker\)\>/
" syn match goExtraType /\<reflect\.\%(Kind\|Type\|Value\)\>/
" syn match goExtraType /\<unsafe\.Pointer\>/

hi def link     goExtraType         Type
hi def link     goSpaceError        Error



" included from: https://github.com/athom/more-colorful.vim/blob/master/after/syntax/go.vim
"
" Comments; their contents
syn keyword     goTodo              contained NOTE
hi def link     goTodo              Todo

syn match goVarArgs /\.\.\./

" Operators;
" match single-char operators:          - + % < > ! & | ^ * =
" and corresponding two-char operators: -= += %= <= >= != &= |= ^= *= ==
syn match goOperator /[-+%<>!&|^*=]=\?/
" match / and /=
syn match goOperator /\/\%(=\|\ze[^/*]\)/
" match two-char operators:               << >> &^
" and corresponding three-char operators: <<= >>= &^=
syn match goOperator /\%(<<\|>>\|&^\)=\?/
" match remaining two-char operators: := && || <- ++ --
syn match goOperator /:=\|||\|<-\|++\|--/
" match ...

hi def link     goPointerOperator   goOperator
hi def link     goVarArgs           goOperator
hi def link     goOperator          Operator

" Functions;
syn keyword goDeclaration func
hi def link     goFunction          Function

" Function calls;
syn match goFunctionCall      /\w\+\ze(/ contains=goBuiltins,goDeclaration
hi def link     goFunctionCall      Type

" Structs & Interfaces;
syn match goTypeConstructor      /\<\w\+{\@=/
syn match goTypeDecl             /\<type\>/ nextgroup=goTypeName skipwhite skipnl
syn match goTypeName             /\w\+/ contained nextgroup=goDeclType skipwhite skipnl
syn match goDeclType             /\<\%(interface\|struct\)\>/ skipwhite skipnl
hi def link     goReceiverType      Type
hi def link     goTypeConstructor   Type
hi def link     goTypeName          Type
hi def link     goTypeDecl          Keyword
hi def link     goDeclType          Keyword

" Variable Assignments
syn match goVarAssign /\v[_.[:alnum:]]+(,\s*[_.[:alnum:]]+)*\ze(\s*([-^+|^\/%&]|\*|\<\<|\>\>|\&\^)?\=[^=])/
hi def link   goVarAssign         Special

" Variable Declarations
syn match goVarDefs /\v\w+(,\s*\w+)*\ze(\s*:\=)/
hi def link   goVarDefs           Special

" :GoCoverage commands
hi def link goCoverageNormalText Comment

function! s:hi()
  hi def link goSameId Search
  hi def link goDiagnosticError SpellBad
  hi def link goDiagnosticWarning SpellRare

  " TODO(bc): is it appropriate to define text properties in a syntax file?
  " The highlight groups need to be defined before the text properties types
  " are added, and when users have syntax enabled in their vimrc after
  " filetype plugin on, the highlight groups won't be defined when
  " ftplugin/go.vim is executed when the first go file is opened.
  " See https://github.com/fatih/vim-go/issues/2658.
  if has('textprop')
    if empty(prop_type_get('goSameId'))
      call prop_type_add('goSameId', {'highlight': 'goSameId'})
    endif
    if empty(prop_type_get('goDiagnosticError'))
      call prop_type_add('goDiagnosticError', {'highlight': 'goDiagnosticError'})
    endif
    if empty(prop_type_get('goDiagnosticWarning'))
      call prop_type_add('goDiagnosticWarning', {'highlight': 'goDiagnosticWarning'})
    endif
  endif

  hi def link goDeclsFzfKeyword        Keyword
  hi def link goDeclsFzfFunction       Function
  hi def link goDeclsFzfSpecialComment SpecialComment
  hi def link goDeclsFzfComment        Comment

  " :GoCoverage commands
  hi def      goCoverageCovered    ctermfg=green guifg=#A6E22E
  hi def      goCoverageUncover    ctermfg=red guifg=#F92672

endfunction

augroup vim-go-hi
  autocmd!
  autocmd ColorScheme * call s:hi()
augroup end
call s:hi()

" Search backwards for a global declaration to start processing the syntax.
"syn sync match goSync grouphere NONE /^\(const\|var\|type\|func\)\>/

" There's a bug in the implementation of grouphere. For now, use the
" following as a more expensive/less precise workaround.
syn sync minlines=500

let b:current_syntax = "go"

" vim: sw=2 ts=2 et
