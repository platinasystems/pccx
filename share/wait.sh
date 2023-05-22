: ${WAIT_PERIOD_SECS:=3}
: ${WAIT_ITERATIONS:=90}
: ${PGCONNECT_TIMEOUT:=$(($WAIT_PERIOD_SECS * $WAIT_ITERATIONS))}

pccx_wait() {
	: ${1:?incomplete}
	eval pccx_wait_$@
}

pccx_wait_period() {
	pccx_wait_period_secs=$(($(date +%s) - wait_start))
	if test $pccx_wait_period_secs -ge $PGCONNECT_TIMEOUT
	then
		echo ${0##*/}: $@ timeout at $pccx_wait_period_secs seconds >&2
		return 1
	fi
	sleep $WAIT_PERIOD_SECS
}

pccx_wait_postgres() {
	: ${HOST_POSTGRES:?unspecifed}
	: ${PORT_POSTGRES:?unspecifed}
	: ${POSTGRES_USER:?unspecifed}
	: ${POSTGRES_PASSWORD:?unspecifed}
	wait_start=$(date +%s)
	until (PGPASSWORD="$POSTGRES_PASSWORD" \
		PGCONNECT_TIMEOUT=$PGCONNECT_TIMEOUT \
		psql -h $HOST_POSTGRES -p $PORT_POSTGRES -U $POSTGRES_USER \
		-c "select 1" >/dev/null 2>&1)
	do
		pccx wait period $HOST_POSTGRES:$PORT_POSTGRES
	done
	echo $HOST_POSTGRES:$PORT_POSTGRES: available
}

pccx_wait_service() {
	: ${1:?unspecified host}
	: ${2:?unspecified port}
	wait_start=$(date +%s)
	until nc -zw3 $1 $2
	do
		pccx wait_period $1:$2
	done
	echo $1:$2: available
}

pccx_wait_url() {
	: ${1:?unspecified url}
	: ${2:?unspecified pattern}
	wait_start=$(date +%s)
	until curl --connect-timeout $PGCONNECT_TIMEOUT -s $1 | grep -q "$2"
	do
		pccx wait period $1
	done
	echo $1: available
}
