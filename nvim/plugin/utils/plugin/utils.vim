" wengwengweng

command! -nargs=1 Rename :call utils#rename(<q-args>)
command! -nargs=0 Delete :call utils#delete()
command! -nargs=1 Copy :call utils#copy(<q-args>)
command! -nargs=1 Mkdir :call utils#mkdir(<q-args>)
command! -nargs=0 Close :call utils#close()
command! -nargs=0 Cdtcb :call utils#cdtcb()
command! -nargs=0 Open :call utils#open()
command! -nargs=? Make :call utils#make(<q-args>)
command! -nargs=0 SynCheck :call utils#syncheck()

