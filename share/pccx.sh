# On demand source of file containing function.
pccx() {
	pccx1=$(echo ${1:?incomplete} | tr -d -); shift
	pccx_func=pccx_$pccx1
	command -v $pccx_func >/dev/null ||
		. ${PCCX_SHARE:=/usr/share/pccx}/$pccx1.sh
	$pccx_func $@
}
