pccx_password() {
	: ${1:?incomplete}
	eval pccx_password_$@
}

pccx_password_decode() {
	pccx pem deencap $@ | pccx base64 decode | pccx pkey decrypt
}

pccx_password_encode() {
	pccx pkey encrypt | pccx base64 encode | pccx pem encap PASSWORD
}

pccx_password_import() {
	: ${1:?missing name}
	eval $1=$(pccx password decode $PCCX_ETC/$1.pem)
}
