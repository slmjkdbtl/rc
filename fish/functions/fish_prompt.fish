# wengwengweng

function fish_prompt

	echo ""
	echo -n " "
	set_color $fish_color_cwd
	echo -n (prompt_pwd)
	set_color normal
	echo -n " > "

end
