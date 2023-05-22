pccx_compose() {
	if test $# -gt 0 && command -v pccx_compose_$1 >/dev/null; then
		eval pccx_compose_$@
		return $?
	fi
	pccx_compose_env=$PCCX_ETC/docker-compose.env
	for f in $pccx_compose_env $PCCX_ETC/pccx.env; do
		if test ! -r $f; then
			echo $f: not found, try \`pccx configure\' >&2
			return 1
		fi
	done
	docker compose -p pccx \
		--project-directory $PWD \
		--file $PCCX_SHARE/docker-compose.yml \
		--env-file $pccx_compose_env $@
}

pccx_compose_configure() {
	: ${1:?missing default env file name}
	: ${2:?missing compose env file name}
	if test ! -f $2; then
		mkdir -p -m 0755 ${2%/*}
		pccx file create 0664 $2 cat <<-EOF
			PCCX_ETC=$PCCX_ETC
			PCCX_LIBEXEC=$PCCX_LIBEXEC
			PCCX_LOG=$PCCX_LOG
			PCCX_SHARE=$PCCX_SHARE
			PCCX_VAR=$PCCX_VAR
		EOF
	fi
	grep '^\(HOST_\|IMAGE_\|PORT_\|RESTART\|TLSX_\)\w*=' $1 |
	while read name_eq_val; do
		name=${name_eq_val%=*}
		grep -q "^${name}=" $2 || echo $name_eq_val >>$2
	done
	pccx file filter $2 sort
}

pccx_compose_deconfigure() {
	: ${1:?missing default env file name}
	: ${2:?missing compose env file name}
	test -r $2 || return 0
	pccx file filter $2 sort
	pccx file filter $2 comm -13 $1 -
}
