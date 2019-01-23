" wengwengweng

let s:meanings = []

func! tommywiseau#add(meaning, options)

	let s:meanings = s:meanings + [{
		\ 'text': a:meaning,
		\ 'pitch': get(a:options, 'pitch', 0),
		\ 'speed': get(a:options, 'speed', 0),
		\ 'volume': get(a:options, 'volume', 100),
		\ 'gap': get(a:options, 'gap', 0),
		\ 'capital': get(a:options, 'capital', 20),
		\ 'accent': get(a:options, 'accent', 'en'),
		\ 'voice': get(a:options, 'voice', 'm4'),
	\ }]

	return 0

endfunc

func! tommywiseau#get()

	return s:meanings[localtime() % len(s:meanings)]

endfunc

func! tommywiseau#say(meaning)

	if !executable('espeak')

		echo 'espeak not found'
		return -1

	endif

	echo 'do you understand life?'

	let cmd = 'espeak -z' .
				\ ' "' . a:meaning.text . '"' .
				\ ' -p ' . a:meaning.pitch .
				\ ' -s ' . a:meaning.speed .
				\ ' -a ' . a:meaning.volume .
				\ ' -k ' . a:meaning.capital .
				\ ' -g ' . a:meaning.gap .
				\ ' -v ' . a:meaning.accent . '+' . a:meaning.voice

	if exists('*jobstart')
		call jobstart(cmd)
	elseif exists('*job_start')
		call job_start(cmd)
	else
		call system(cmd)
	endif

endfunc

