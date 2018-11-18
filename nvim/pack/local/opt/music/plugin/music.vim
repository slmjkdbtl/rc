" wengwengweng

command! MusicPlay
			\ call music#play()

command! MusicPause
			\ call music#pause()

command! MusicToggle
			\ call music#toggle()

command! MusicPrev
			\ call music#prev()

command! MusicNext
			\ call music#next()

command! MusicVolDown
			\ call music#voldown()

command! MusicVolUp
			\ call music#volup()

command! MusicList
			\ call music#list()

call music#update_status()

