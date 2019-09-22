# wengwengweng

function breaksong

	set in $argv[1]
	set pts $argv[2..-1]
	set start "0:00"

	for i in (seq (count $pts))

		set out (basename $in .mp3)"_"$i".mp3"
		set end $pts[$i]

		echo $start"-"$end" -> "$out
		ffmpeg -i $in -ss $start -to $end -c copy -loglevel panic $out

		set start $end

	end

end

