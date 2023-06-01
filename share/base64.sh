pccx_base64() {
	: ${1:?incomplete}
	eval pccx_base64_$@
}

pccx_base64_decode() {
	openssl enc -base64 -d
}

pccx_base64_encode() {
	openssl enc -base64 -e
}
