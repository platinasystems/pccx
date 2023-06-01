pccx_ssh() {
	: ${1:?incomplete}
	eval pccx_ssh_$@
}

pccx_ssh_keygen() {
	: ${1:?missing private rsa key file name}
	ssh-keygen -q -t rsa -b 2048 -N '' -f $1
}
