" wengwengweng

let s:srcdir = expand('<sfile>:p:h:h')
let g:syntax_list = get(g:, 'syntax_list', [])

exec 'set rtp^=' . s:srcdir . ''
call syntax#add('*.hx', 'haxe', 'jdonaldson/vaxe', '//\ %s')
call syntax#add('*.lua', 'lua', 'tbastos/vim-lua', '--\ %s')
call syntax#add('*.rs', 'rust', 'rust-lang/rust.vim', '//\ %s')
call syntax#add('*.ck', 'chuck', 'wilsaj/chuck.vim', '//\ %s')
call syntax#add('*.fish', 'fish', 'dag/vim-fish', '#\ %s')
call syntax#add('*.ex', 'elixir', 'elixir-editors/vim-elixir', '#\ %s')
call syntax#add('*.glsl', 'glsl', 'tikhomirov/vim-glsl', '//\ %s')
call syntax#add('*.scss', 'scss', 'cakebaker/scss-syntax.vim', '//\ %s')
call syntax#add('*.toml', 'toml', 'cespare/vim-toml', '#\ %s')
call syntax#add('*.{scpt,applescript}', 'applescript', 'mityu/vim-applescript', '--\ %s')
call syntax#add('*.{md,markdown}', 'markdown', 'plasticboy/vim-markdown', '%s')
call syntax#add('*/nginx/*.conf', 'nginx', 'chr4/nginx.vim', '#\ %s')
call syntax#load()

