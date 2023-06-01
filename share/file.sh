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
	pccx_file_filter_name=${1:?missing <name>}
	shift
	t=$(mktemp); exec 8<$t 9>$t; rm $t
	<$pccx_file_filter_name eval $@ >&9
	<&8 cat >$pccx_file_filter_name
	exec 8>&- 9>&-
}
