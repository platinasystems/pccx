pccx_rsa() {
	: ${1:?incomplete}
	eval pccx_rsa_$@
}

pccx_rsa_gen() {
	: ${1:?missing private rsa key file name}
	ssh-keygen -q -t rsa -b 2048 -N '' -f $1
}
