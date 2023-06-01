# Set pccx_prompt_ret with text returned by query.
# Options:
#	--no-echo
pccx_prompt() {
	unset pccx_prompt_ret
	if test "$1" = "--no-echo"; then
		shift
		printf 'Enter %s: ' "$*"
		pccx_prompt_restore=`stty -g`
		stty -echo
		trap "stty $pccx_prompt_restore" INT
		read -r pccx_prompt_ret
		trap - INT
		stty $pccx_prompt_restore
		echo
	else
		printf 'Enter %s: ' "$*"
		read pccx_prompt_ret
	fi
}
