pccx_file() {
	: ${1:?incomplete}
	eval pccx_file_$@
}

pccx_file_create() {
	: ${1:?missing <mode>}
	: ${2:?missing <name>}
	exec 8>$2
	chmod $1 $2
	shift 2
	test $# -eq 0 || eval $@ >&8
	exec 8>&-
}

pccx_file_filter() {
	: ${1:?missing <name>}
	exec 8<>$1
	shift
	t=$(mktemp); exec 9<>"$t"; rm "$t"
	eval $@ <&8 >&9
	exec 8<>/dev/fd/8 9<>/dev/fd/9
	cat <&9 >&8
	exec 8>&- 9>&-
}
