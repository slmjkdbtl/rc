" wengwengweng

let g:bookmark_file = get(g:, 'bookmark_file', '~/.bookmarks')

command! -nargs=? Bookmark
			\ call bookmark#jump(<q-args>)

command! -nargs=? BookmarkAdd
			\ call bookmark#add(<q-args>)

command! -nargs=? BookmarkRemove
			\ call bookmark#remove(<q-args>)

command! -nargs=0 BookmarkList
			\ call bookmark#list()

