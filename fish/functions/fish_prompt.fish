# wengwengweng

function fish_prompt

	function show_cwd

		set_color -o green
		set -g fish_prompt_pwd_dir_length 0
		echo -n (prompt_pwd)
		set_color normal

	end

	function show_git

		git rev-parse --abbrev-ref HEAD >/dev/null 2>&1

		if test $status -eq 0

			set_color -d normal
			echo -n " "
			echo -n (git rev-parse --abbrev-ref HEAD)

			if test -n (echo (git diff))
				echo -n "*"
			end

		end

	end

	function show_prompt

		set_color normal
		echo -n "> "

	end

	echo ""
	echo -n " "
	show_cwd
	show_git
	echo ""
	echo -n " "
	show_prompt

	functions -e show_cwd
	functions -e show_git
	functions -e show_prompt

end
