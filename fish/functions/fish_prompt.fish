# wengwengweng

function fish_prompt

	function show_cwd

		set_color -o green
		set -g fish_prompt_pwd_dir_length 0
		echo -n (prompt_pwd)
		set_color normal

	end

	function show_git

		set_color $fish_color_git
		echo -n (__fish_git_prompt | string trim | string replace '(' '' | string replace ')' '')
		set_color normal

	end

	function show_prompt

		set_color normal
		echo -n "> "

	end

	echo ""
	echo -n " "
	show_cwd
	echo -n " "
	show_git
	echo ""
	echo -n " "
	show_prompt

	functions -e show_cwd
	functions -e show_git
	functions -e show_prompt

end
