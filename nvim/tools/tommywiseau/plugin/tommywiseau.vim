" wengwengweng

let g:sex_life_count = get(g:, 'sex_life_count', 0)
let g:is_human_bean = get(g:, 'is_human_bean', 1)

call tommywiseau#add('oh Hi mark!', { 'speed': 100, 'capital': 60 })
call tommywiseau#add('Do you understand Life?', { 'speed': 50 })
call tommywiseau#add("anyway, how's your sex life?", {})
call tommywiseau#add("You're Tearing me apart lisa", { 'volume': 200 })
call tommywiseau#add('chip chip chip chip chip chip chip chip chip chip chip chip chip chip!', { 'pitch': 200, 'speed': 200, 'voice': 'f5' })
call tommywiseau#add("Hahaha you must be kidding aren't you", { 'pitch': 30 })
call tommywiseau#add("I did not hit her it's not true it's bullshit I did not hit her I did naaaaaaaaaat", { 'pitch': 30 })

command! MeaningOfLife
			\ call tommywiseau#say(tommywiseau#get())

augroup Enlightment

	autocmd!

	if g:is_human_bean

		autocmd VimEnter *
					\ MeaningOfLife

		if g:sex_life_count >= 999

			autocmd BufEnter *
						\ MeaningOfLife

		end

	endif

augroup END

