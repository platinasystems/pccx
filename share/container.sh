pccx_container() {
	: ${1:?incomplete}
	eval pccx_container_$@
}

pccx_container_debconf() {
	: ${1:?missing container env file name}
	pccx_container_load $1
	if test -z "$MINIO_ROOT_PASSWORD"; then
		db_get pccx/MINIO_ROOT_PASSWORD || pccx error
		MINIO_ROOT_PASSWORD="${RET:-miniominio}"
		db_reset pccx/MINIO_ROOT_PASSWORD
	fi
	if test -z "$POSTGRES_PASSWORD"; then
		db_get pccx/POSTGRES_PASSWORD || pccx error
		POSTGRES_PASSWORD=$RET
		: ${POSTGRES_PASSWORD:?empty}
		db_reset pccx/POSTGRES_PASSWORD
	fi
	for name in \
		DB_PASSWORD_KEYMANAGER \
		DB_PASSWORD_MAAS \
		DB_PASSWORD_PCC \
		DB_PASSWORD_PHONEHOME \
		DB_PASSWORD_PLATINAEXECUTOR \
		DB_PASSWORD_PLATINAMONITOR \
		DB_PASSWORD_POSTGRES \
		DB_PASSWORD_SECURITY \
		DB_PASSWORD_USERMANAGEMENT \
		GATEWAY_KEYSTORE_PASSWORD \
		KAFKA_PASSWORD \
		MAILER_PASSWORD \
		PHONEHOME_SECRET_KEY \
		SECURITY_ADMIN_PASSWORD \
	; do
		eval pccx_val=\$$pccx_name
		if test -z "$val"; then
			db_get pccx/$name || pccx error
			eval $name="${RET:-$POSTGRES_PASSWORD}"
			db_reset pccx/$name
		fi
	done
	pccx_container_update $1
}

pccx_container_load() {
	: ${1:?missing container env file name}
	test -r $1 || return 0
	for pccx_name in \
		POSTGRES_PASSWORD \
		DB_PASSWORD_KEYMANAGER \
		DB_PASSWORD_MAAS \
		DB_PASSWORD_PCC \
		DB_PASSWORD_PHONEHOME \
		DB_PASSWORD_PLATINAEXECUTOR \
		DB_PASSWORD_PLATINAMONITOR \
		DB_PASSWORD_POSTGRES \
		DB_PASSWORD_SECURITY \
		DB_PASSWORD_USERMANAGEMENT \
		GATEWAY_KEYSTORE_PASSWORD \
		KAFKA_PASSWORD \
		MAILER_PASSWORD \
		PHONEHOME_SECRET_KEY \
		SECURITY_ADMIN_PASSWORD \
	; do
		pccx_name_eq_val=$(grep "^${pccx_name}=" $1)
		test -z "$pccx_name_eq_val" || eval $pccx_name_eq_val
	done
}

pccx_container_prompt() {
	: ${1:?missing container env file name}
	pccx_container_load $1
	test -n "$POSTGRES_PASSWORD" ||
		pccx prompt --no-echo POSTGRES_PASSWORD
	for pccx_name in \
		DB_PASSWORD_KEYMANAGER \
		DB_PASSWORD_MAAS \
		DB_PASSWORD_PCC \
		DB_PASSWORD_PHONEHOME \
		DB_PASSWORD_PLATINAEXECUTOR \
		DB_PASSWORD_PLATINAMONITOR \
		DB_PASSWORD_POSTGRES \
		DB_PASSWORD_SECURITY \
		DB_PASSWORD_USERMANAGEMENT \
		GATEWAY_KEYSTORE_PASSWORD \
		KAFKA_PASSWORD \
		MAILER_PASSWORD \
		PHONEHOME_SECRET_KEY \
		SECURITY_ADMIN_PASSWORD \
	; do
		eval pccx_val=\$$pccx_name
		if test -z "$val"; then
			pccx prompt --no-echo $pccx_name \
				'(default POSTGRES_PASSWORD)'
			eval pccx_val=\$$pccx_name
			test -n "$pccx_val" ||
				eval $pccx_name=$POSTGRES_PASSWORD
		fi
	done

	test -n "$MINIO_ROOT_PASSWORD" ||
		pccx prompt --no-echo MINIO_ROOT_PASSWORD '(default miniominio)'
	test -n "$MINIO_ROOT_PASSWORD" ||
		MINIO_ROOT_PASSWORD=miniominio
	pccx_container_update $1
}

pccx_container_update() {
	: ${1:?missing container env file name}

	test -d ${1%/*} || mkdir -p -m 0660 ${1%/*}
	test -w $1 || pccx file create 0664 $1

	case $(uname -m) in
	arm64 ) : ${JAVA_OPTS:=-Djdk.lang.Process.launchMechanism=vfork};;
	esac

	for pccx_name in \
		DB_PASSWORD_KEYMANAGER \
		DB_PASSWORD_MAAS \
		DB_PASSWORD_PCC \
		DB_PASSWORD_PHONEHOME \
		DB_PASSWORD_PLATINAEXECUTOR \
		DB_PASSWORD_PLATINAMONITOR \
		DB_PASSWORD_POSTGRES \
		DB_PASSWORD_SECURITY \
		DB_PASSWORD_USERMANAGEMENT \
		GATEWAY_KEYSTORE_PASSWORD \
		JAVA_OPTS \
		KAFKA_PASSWORD \
		MAILER_PASSWORD \
		MINIO_ROOT_PASSWORD \
		PHONEHOME_SECRET_KEY \
		POSTGRES_PASSWORD \
		SECURITY_ADMIN_PASSWORD \
	; do
		eval pccx_val=\$$pccx_name
		test -z "$pccx_val" || grep -q "^${pccx_name}=" $1 ||
			echo "$pccx_name='$pccx_val'" >>$1
	done
	pccx file filter $1 sort
}
