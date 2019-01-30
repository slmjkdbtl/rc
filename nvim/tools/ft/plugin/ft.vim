" wengwengweng

call ft#detect('*.toml', 'toml')
call ft#detect('*.carp', 'carp')
call ft#detect('*.metal', 'c')
call ft#detect('*.elm', 'elm')
call ft#detect('*.fish', 'fish')
call ft#detect('*.swift', 'swift')
call ft#detect('*.dyon', 'dyon')
call ft#detect('*.ck', 'chuck')
call ft#detect('*.scd', 'supercollider')
call ft#detect('*.{vert,frag}', 'glsl')
call ft#detect('Tupfile', 'tup')

call ft#comment('*.cs', '//%s')
call ft#comment('*.swift', '//%s')
call ft#comment('*.{vert,frag}', '//%s')
call ft#comment('*.toml', '#%s')

