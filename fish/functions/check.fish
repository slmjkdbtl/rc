# wengwengweng

function check

	if curl -s -m 3 --head --request GET https://www.wengwengweng.me/ | grep "200 OK" > /dev/null 2>&1

		set_color green
		echo "- website up"
		set_color normal

	else

		set_color red
		echo "- website down"
		set_color normal

	end

end

