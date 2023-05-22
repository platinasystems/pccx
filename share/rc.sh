. /usr/share/pccx/pccx.sh
. /usr/share/pccx/default.env

exec >/var/log/pccx.log 2>&1

if test -d /home; then
	cd /home
	test ! -d logs || mount --bind /var/log /home/logs
fi

# For security, don't source admin file; instead, evaluate each matching
# default variable.
for vv in $(grep '^\w\+=' /etc/pccx/pccx.env); do
	test -z $(grep "^${vv%=*}=" /usr/share/pccx/default.env) || eval $vv
done

# Also, evaluate these admin file variables.
for v in \
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
	vv=$(grep "^$v=" /etc/pccx/pccx.env)
	test -z "$vv" || eval $vv
done

KAFKA_ADV_HOST=$HOST_KAFKA
MINIO_PORT=$PORT_MINIO
ORCHESTRATION_REPO_REFERENCE=$CONFIG_BRANCH_MAAS

URI_APIREGISTRY=http://${HOST_APIREGISTRY}:${PORT_APIREGISTRY}
URI_EUREKA=${URI_APIREGISTRY}/eureka
URI_KAFKA=http://$HOST_KAFKA:$PORT_KAFKA_REGISTRY
URI_MINIO=http://$HOST_MINIO:$PORT_MINIO
URI_PROMETHUS=http://$HOST_PROMETHEUS:$PORT_PROMETHEUS/api/v1/targets
URI_PUSHGATEWAY=http://$HOST_PUSHGATEWAY:$PORT_PUSHGATEWAY/api/v1/status
