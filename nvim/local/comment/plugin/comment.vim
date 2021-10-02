" wengwengweng

command! -range CommentToggle
			\ <line1>,<line2>call comment#toggle()

command! -range CommentOn
			\ <line1>,<line2>call comment#on()

command! -range CommentOff
			\ <line1>,<line2>call comment#off()
