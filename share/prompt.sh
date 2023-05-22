# Set variable named by first argument with remaining prompt.
# e.g. this sets ${user} with input up to newline
#
#	pccx_prompt user name '(default: FOO)'
#	> Enter user name (default: FOO): <input>
pccx_prompt() {
	if test "$1" = "--no-echo"; then
		shift
		pccx_prompt_no_echo $@
		return $?
	fi
	printf 'Enter %s: ' "$*"
	pccx_prompt_v=${1:?missing <var>}
	eval read "$pccx_prompt_v"
}

# Silently set variable named by first argument with remaining prompt.
# e.g. this sets ${password} with non-echo'd input up to newline
#
#	pccx_prompt --no-echo password '(default: FOO)'
#	> Enter password (default: FOO): <input>
pccx_prompt_no_echo() {
	eval pccx_prompt_no_echo_v=${1:?missing <var>}
	printf 'Enter %s: ' "$*"
	pccx_prompt_no_echo_restore=`stty -g`
	stty -echo
	trap "stty $pccx_prompt_no_echo_restore" INT
	eval read -r "$pccx_prompt_no_echo_v"
	trap - INT
	stty $pccx_prompt_no_echo_restore
	echo
}
