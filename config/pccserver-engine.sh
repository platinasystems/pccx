#!/bin/sh

set -e
set -x

for env in env kafka minio pccserver; do
	. /run/secrets/${env}
	export $(sed -n '/^\w\+=/s/=.*//p' /run/secrets/${env})
done

cd /home
/home/scripts/microservice/boot.sh -l go -m "$SERVICE_DEBUG_ENABLED" -t pccserver -b "--overrideSystemProperties --configProfile docker --dbHost "$PCC_DB_HOST" --dbName "$SERVICE_DB" --dbUsername "$SERVICE_DB_USER" --dbPassword "$SERVICE_DB_PASSWORD" --configUri "$SERVICE_CONFIG_URI" --phAccessKey "$PHONEHOME_ACCESS_KEY" --phSecretKey "$PHONEHOME_SECRET_KEY" --useHostnameAsAddress --useHostnameAsName --registryAddress registry --maxRegistrationRetry 5 --publicAddress "$HOST_IP" --configBranch "$SERVICE_CONFIG_BRANCH"" -i -d "$SERVICE_DB" -u "$SERVICE_DB_USER" -p "$SERVICE_DB_PASSWORD"
