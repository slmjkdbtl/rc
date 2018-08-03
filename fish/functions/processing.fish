# wengwengweng

function processing -d "run processing projects"

	set -g dir $PWD
	set -g project (basename $dir)
	echo $project
	processing-java --sketch=$PWD --run

end
