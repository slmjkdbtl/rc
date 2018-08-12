" wengwengweng

call plug#begin()
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'mhinz/vim-signify'
Plug 'mhartington/oceanic-next'
Plug 'tbastos/vim-lua'
Plug 'cespare/vim-toml'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'digitaltoad/vim-pug'
Plug 'tikhomirov/vim-glsl'
Plug 'dag/vim-fish'
Plug 'wilsaj/chuck.vim'
Plug 'Shougo/unite.vim'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
call plug#end()

" color
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 0

" vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_force_overwrite_statusline = 0
let g:vimfiler_no_default_key_mappings = 1
let g:vimfiler_enable_auto_cd = 1
let g:vimfiler_ignore_filters = ['matcher_ignore_wildignore']

command! Filer
			\ silent! VimFilerCurrentDir -parent -simple

command! FilerProject
			\ silent! VimFilerCurrentDir -parent -simple -edit-action=tabopen

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
let g:ctrlp_reuse_window = 'vimfiler'
let g:ctrlp_open_func = { 'files': 'CtrlpOpenFile' }

func! CtrlpOpenFile(action, line)

	let l:name = fnameescape(fnamemodify(a:line, ':p'))

	if isdirectory(l:name)
		exec 'lcd ' . l:name
		FilerProject
	elseif filereadable(l:name)
		exec 'edit ' . l:name
	endif

	call ctrlp#exit()

endfunc

let g:ctrlp_prompt_mappings = {
	\ 'PrtBS()':              ['<bs>'],
	\ 'PrtDelete()':          [],
	\ 'PrtDeleteWord()':      ['<m-bs>'],
	\ 'PrtClear()':           [],
	\ 'PrtSelectMove("j")':   ['<down>'],
	\ 'PrtSelectMove("k")':   ['<up>'],
	\ 'PrtSelectMove("t")':   [],
	\ 'PrtSelectMove("b")':   [],
	\ 'PrtSelectMove("u")':   [],
	\ 'PrtSelectMove("d")':   [],
	\ 'PrtHistory(-1)':       [],
	\ 'PrtHistory(1)':        [],
	\ 'AcceptSelection("e")': ['<cr>'],
	\ 'AcceptSelection("h")': [],
	\ 'AcceptSelection("t")': [],
	\ 'AcceptSelection("v")': [],
	\ 'ToggleFocus()':        [],
	\ 'ToggleRegex()':        [],
	\ 'ToggleByFname()':      [],
	\ 'ToggleType(1)':        [],
	\ 'ToggleType(-1)':       [],
	\ 'PrtExpandDir()':       [],
	\ 'PrtInsert("c")':       [],
	\ 'PrtInsert()':          [],
	\ 'PrtCurStart()':        [],
	\ 'PrtCurEnd()':          [],
	\ 'PrtCurLeft()':         [],
	\ 'PrtCurRight()':        [],
	\ 'PrtClearCache()':      [],
	\ 'PrtDeleteEnt()':       [],
	\ 'CreateNewFile()':      [],
	\ 'MarkToOpen()':         [],
	\ 'OpenMulti()':          [],
	\ 'PrtExit()':            ['<esc>'],
	\ }

" tommywiseau
let g:is_human_bean = 0

" projekt
let g:projekt_switch_action = 'FilerProject'

" unload default plugins
let g:loaded_netrwPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_spellfile_plugin = 1
