pccx_configure () {
	mkdir -p $PCCX_ETC $PCCX_LOG $PCCX_VAR
	if test $# -ne 0; then
		eval pccx_configure_$@
		return $?
	fi
	pccx configure compose
	test -e $PCCX_KEY || pccx pkey gen
	pccx passwords prompt
	test -e $PCCX_ETC/pub.pem || pccx pkey pubout
	test -e $PCCX_ETC/ssh.pub || pccx pkey tossh
	test -e $PCCX_ETC/cert.pem || pccx cert prompt
}

pccx_configure_compose() {
	if test ! -f $PCCX_ETC/docker-compose.env; then
		pccx file create 0664 $PCCX_ETC/docker-compose.env cat <<-EOF
			PCCX_ETC=$PCCX_ETC
			PCCX_LIBEXEC=$PCCX_LIBEXEC
			PCCX_LOG=$PCCX_LOG
			PCCX_SHARE=$PCCX_SHARE
			PCCX_VAR=$PCCX_VAR
			PCCX_KEY=$PCCX_KEY
			PCCX_FIXME=$PCCX_FIXME
		EOF
	fi

	grep '^\(HOST_\|IMAGE_\|PORT_\|RESTART\|TLSX_\)\w*=' \
		$PCCX_SHARE/default.env |
	while read name_eq_val; do
		name=${name_eq_val%=*}
		grep -q "^${name}=" $PCCX_ETC/docker-compose.env ||
			echo $name_eq_val >>$PCCX_ETC/docker-compose.env
	done

	case $(uname -m) in
	arm64 | aarch64 )
		: ${JAVA_OPTS:=-Djdk.lang.Process.launchMechanism=vfork}
		grep -q "^JAVA_OPTS=" $PCCX_ETC/docker-compose.env ||
			echo JAVA_OPTS=$JAVA_OPTS >>$PCCX_ETC/docker-compose.env
		;;
	esac

	pccx file filter $PCCX_ETC/docker-compose.env sort
}
