pccx_passwords() {
	if test $# -ne 0; then
		eval pccx_passwords_$@
		return $?
	fi
	pccx password import gateway_keystore_password
	pccx password import kafka_password
	pccx password import keymanager_db_password
	pccx password import maas_db_password
	pccx password import mailer_db_password
	pccx password import minio_password
	pccx password import pcc_db_password
	pccx password import phonehome_db_password
	pccx password import phonehome_secret_key
	pccx password import platinaexecutor_db_password
	pccx password import platinamonitor_db_password
	pccx password import postgres_password
	pccx password import postgres_db_password
	pccx password import security_admin_password
	pccx password import security_db_password
	pccx password import usermanagement_db_password
}

pccx_passwords_debconf() {
	if test ! -e $PCCX_ETC/postgres_password.pem; then
		db_get pccx/postgres_password || pccx error
		test -n "$RET" || pccx error postgres_password required
		printf %s $RET |
			pccx password encode >$PCCX_ETC/postgres_password.pem
		db_reset pccx/postgres_password
	fi
	for name in \
		keymanager_db_password \
		maas_db_password \
		pcc_db_password \
		phonehome_db_password \
		platinaexecutor_db_password \
		platinamonitor_db_password \
		postgres_db_password \
		security_db_password \
		usermanagement_db_password \
		gateway_keystore_password \
		kafka_password \
		mailer_password \
		phonehome_secret_key \
		security_admin_password \
	; do
		if test -e $PCCX_ETC/$name.pem; then
			continue
		fi
		db_get pccx/$name || pccx error
		if test -n "$RET"; then
			printf %s $RET |
				pccx password encode >$PCCX_ETC/$name.name
			db_reset pccx/$name
		else
			ln $PCCX_ETC/postgres_password $PCCX_ETC/$name.pem
		fi
	done
	if test ! -e $PCCX_ETC/minio_password.pem; then
		db_get pccx/minio_password || pccx error
		printf %s ${RET:-miniominio} |
			pccx password encode >$PCCX_ETC/minio_password.pem
		db_reset pccx/minio_password
	fi
}

pccx_passwords_prompt() {
	test -e $PCCX_FIXME ||
		pccx file create 0600 $PCCX_FIXME
	if test ! -e $PCCX_ETC/postgres_password.pem; then
		pccx prompt --no-echo postgres_password
		test -n "$pccx_prompt_ret" ||
			pccx error postgres_password required
		printf %s $pccx_prompt_ret |
			pccx password encode >$PCCX_ETC/postgres_password.pem
		fixme_postgres=$pccx_prompt_ret
		printf 'postgres_password="%s"\n' $pccx_prompt_ret >>$PCCX_FIXME
	fi
	for name in \
		keymanager_db_password \
		maas_db_password \
		pcc_db_password \
		phonehome_db_password \
		platinaexecutor_db_password \
		platinamonitor_db_password \
		postgres_db_password \
		security_db_password \
		usermanagement_db_password \
		gateway_keystore_password \
		kafka_password \
		mailer_password \
		phonehome_secret_key \
		security_admin_password \
	; do
		if test -e $PCCX_ETC/$name.pem; then
			continue
		fi
		pccx prompt --no-echo $name '(default <postgres_password>)'
		if test -n "$pccx_prompt_ret"; then
			printf %s $pccx_prompt_ret |
				pccx password encode >$PCCX_ETC/$name.pem
		else
			ln $PCCX_ETC/postgres_password.pem $PCCX_ETC/$name.pem
			pccx_prompt_ret=$fixme_postgres
		fi
		printf '%s="%s"\n' $name $pccx_prompt_ret >>$PCCX_FIXME
	done
	if test ! -e $PCCX_ETC/minio_password.pem; then
		pccx prompt --no-echo 'minio_password (default "miniominio")'
		test -n "$pccx_prompt_ret" ||
			pccx_prompt_ret=miniominio
		printf %s $pccx_prompt_ret |
			pccx password encode >$PCCX_ETC/minio_password.pem
		printf 'minio_password="%s"\n' $pccx_prompt_ret >>$PCCX_FIXME
	fi
}
