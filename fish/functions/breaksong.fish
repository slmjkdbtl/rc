# wengwengweng

function breaksong -d "break whole album into songs"

	set -l in $argv[1]
	set -l pts $argv[2..-1]
	set -l start "0:00"

	for i in (seq (count $pts))

		set -l out (basename $in .mp3)"_"$i".mp3"
		set -l end $pts[$i]

		echo $start"-"$end" -> "$out
		ffmpeg -i $in -ss $start -to $end -c copy -loglevel panic $out

		set -l start $end

	end

end

