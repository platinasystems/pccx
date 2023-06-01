pccx_pkey() {
	: ${1:?incomplete}
	case "$1" in
	check | gen | decrypt | encrypt | pubcheck | pubout | tossh )
		eval pccx_pkey_$@
		;;
	*)	openssl pkey $@
		;;
	esac
}

pccx_pkey_check() {
	openssl pkey -check ${@:--in $PCCX_KEY}
}

pccx_pkey_gen() {
	pccx file create 0600 $PCCX_KEY openssl genpkey \
		${@:--algorithm rsa -pkeyopt rsa_keygen_bits:4096 -outform pem}
}

pccx_pkey_decrypt() {
	openssl pkeyutl -decrypt ${@:--inkey $PCCX_KEY}
}

pccx_pkey_encrypt() {
	openssl pkeyutl -encrypt ${@:--inkey $PCCX_KEY}
}

pccx_pkey_pubcheck() {
	openssl pkey -pubcheck ${@:--pubin -in $PCCX_ETC/pub.pem}
}

pccx_pkey_pubout() {
	openssl pkey -pubout ${@:--in $PCCX_KEY -out $PCCX_ETC/pub.pem}
}

pccx_pkey_tossh() {
	ssh-keygen -y ${@:--f $PCCX_KEY} > $PCCX_ETC/ssh.pub
}
