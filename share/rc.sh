: ${PCCX_SHARE:=/usr/share/pccx}
: ${PCCX_ETC:=/etc/pccx}
: ${PCCX_KEY:=/run/secrets/key}
: ${PCCX_FIXME:=/run/secrets/fixme}

. $PCCX_SHARE/default.env
. $PCCX_SHARE/pccx.sh

test ! -d /home/logs || mount --bind /var/log /home/logs
exec >/var/log/pccx.log 2>&1

# For security, don't source admin file; instead, evaluate each matching
# default variable.
if test -r $PCCX_ETC/pccx.env; then
	for vv in $(grep '^\w\+=' $PCCX_ETC/pccx.env); do
		test -z $(grep "^${vv%=*}=" $PCCX_SHARE/default.env) ||
			eval $vv
	done
fi

KAFKA_ADV_HOST=$HOST_KAFKA
MINIO_PORT=$PORT_MINIO
ORCHESTRATION_REPO_REFERENCE=$CONFIG_BRANCH_MAAS

URI_APIREGISTRY=http://${HOST_APIREGISTRY}:${PORT_APIREGISTRY}
URI_EUREKA=${URI_APIREGISTRY}/eureka
URI_KAFKA=http://$HOST_KAFKA:$PORT_KAFKA_REGISTRY
URI_MINIO=http://$HOST_MINIO:$PORT_MINIO
URI_PROMETHUS=http://$HOST_PROMETHEUS:$PORT_PROMETHEUS/api/v1/targets
URI_PUSHGATEWAY=http://$HOST_PUSHGATEWAY:$PORT_PUSHGATEWAY/api/v1/status

if command -v openssl >/dev/null && test -r $PCCX_KEY; then
	pccx passwords
elif test -r $PCCX_FIXME; then
	. $PCCX_FIXME
fi

test ! -d /home || cd /home
