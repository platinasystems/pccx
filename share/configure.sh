pccx_configure () {
	test -r $PCCX_ETC/cert.pem -a -r $PCCX_ETC/key.pem ||
		pccx cert prompt $PCCX_ETC/cert.pem $PCCX_ETC/key.pem
	test -f $PCCX_ETC/id_rsa ||
		pccx rsa gen $PCCX_ETC/id_rsa
	pccx compose configure $PCCX_SHARE/default.env \
		$PCCX_ETC/docker-compose.env 
	pccx container prompt $PCCX_ETC/pccx.env 
}
