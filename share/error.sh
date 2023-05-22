pccx_error() {
	echo ${0##*/}: ${@:-$RET} >&2
	false
}
