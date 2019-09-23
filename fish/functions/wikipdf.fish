# wengwengweng

function wikipdf -d "grab wikipedia pdf" -a "name"
	wget -O "$name.pdf" "https://en.wikipedia.org/api/rest_v1/page/pdf/$name"
end

