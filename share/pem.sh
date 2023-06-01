pccx_pem() {
	: ${1:?incomplete}
	eval pccx_pem_$@
}

pccx_pem_deencap() {
	grep -v '^-\+\(BEGIN\|END\)' $@
}

pccx_pem_encap() {
	echo -----BEGIN${@:+ }${@}-----
	cat
	echo -----END${@:+ }${@}-----
}
