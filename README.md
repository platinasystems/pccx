This deploys a *pcc* docker stack.

First run `./init` to enter prompted passwords.

Then override any of these (defaults) within `.env`.

- `ADMINER_IMAGE` (`adminer`)
- `ALERTMANAGER_IMAGE` (`prom/alertmanager`)
- `ANSIBLE_VERBOSE_LEVEL` (`0`)
- `ANSIBLE_VERBOSE_LEVEL` (`0`)
- `API_REGISTRY_DEBUG_ENABLED` (`false`)
- `API_REGISTRY_IMAGE` (`<registry>/registry:<release>`)
- `CADVISOR_IMAGE` (`zcube/cadvisor`)
- `GATEWAY_DEBUG_ENABLED` (`false`)
- `GATEWAY_IMAGE` (`<registry>/gateway:<release>`)
- `GATEWAY_PORT` (`443`)
- `KAFKA_IMAGE` (`landoop/fast-data-dev`)
- `KEYMANAGER_DB` (`key_manager`)
- `KEYMANAGER_DB_USER` (`jwtuser`)
- `KEYMANAGER_DEBUG_ENABLED` (`false`)
- `KEY_MANAGER_IMAGE` (`<registry>/key-manager:<release>`)
- `MAAS_ADDITIONAL_ARGUMENTS` (``)
- `MAAS_CONFIG_BRANCH` (`master`)
- `MAAS_DB` (`maas`)
- `MAAS_DB_USER` (`pcc`)
- `MAAS_DEBUG_ENABLED` (`false`)
- `MAILER_CONFIG_BRANCH` (`master`)
- `MAILER_DEBUG_ENABLED` (`false`)
- `MAILER_IMAGE` (`<registry>/maas:<release>`)
- `MAILER_IMAGE` (`<registry>/mailer:<release>`)
- `MAILER_IMAGE` (`<registry>/monitor:<release>`)
- `MAILER_USER` (`pcc_notifications@platinasystems.com`)
- `MINIO_IMAGE` (`minio/minio`)
- `MONITOR_DEBUG_ENABLED` (`false`)
- `NODE_EXPORTER_IMAGE` (`prom/node-exporter`)
- `PCCSERVER_IMAGE` (`<registry>/pccserver:<release>`)
- `PCCUI_DEBUG_ENABLED` (`false`)
- `PCC_DB` (`pccdb`)
- `PCC_DB_USER` (`pcc`)
- `PCC_DEBUG_ENABLED` (`false`)
- `PCC_UI_IMAGE` (`<registry>/pcc-ui:<release>`)
- `PHONEHOME_DB` (`phone_home`)
- `PHONEHOME_DB_USER` (`phuser`)
- `PHONEHOME_DEBUG_ENABLED` (`false`)
- `PHONE_HOME_IMAGE` (`<registry>/phone-home:<release>`)
- `PLATINAEXECUTOR_CONFIG_BRANCH` (`master`)
- `PLATINAEXECUTOR_DB` (`executordb`)
- `PLATINAEXECUTOR_DB_USER` (`executor`)
- `PLATINAEXECUTOR_DEBUG_ENABLED` (`false`)
- `PLATINAMONITOR_CONFIG_BRANCH` (`master`)
- `PLATINAMONITOR_DB` (`platina_monitor`)
- `PLATINAMONITOR_DB_USER` (`monitor`)
- `PLATINAMONITOR_DEBUG_ENABLED` (`false`)
- `PLATINA_EXECUTOR_IMAGE` (`<registry>/platina-executor:<release>`)
- `PLATINA_MONITOR_IMAGE` (`<registry>/platina-monitor:<release>`)
- `POSTGRES_DB` (`postgres`)
- `POSTGRES_IMAGE` (`postgres`)
- `POSTGRES_USER` (`postgres`)
- `PROMETHEUS_IMAGE` (`prom/prometheus`)
- `PUB_GPG_KEY` (`./phone-home/platina_pubkey.asc`)
- `PUSHGATEWAY_IMAGE` (`prom/pushgateway`)
- `REDIS_IMAGE` (`redis:5.0.3-alpine`)
- `RESTART` (`unless-stopped`)
- `SECURITY_DB` (`jwt`)
- `SECURITY_DB_USER` (`jwtuser`)
- `SECURITY_DEBUG_ENABLED` (`false`)
- `SECURITY_IMAGE` (`<registry>/security:<release>`)
- `TLSX_BEP` (`8004`)
- `TLSX_BET` (`10.100.0.1`)
- `TLSX_BEV` (`10.100.0.0/24`)
- `TLSX_FEP` (`8003`)
- `TLSX_FET` (`10.100.1.1`)
- `TLSX_FEV` (`10.100.1.0/24`)
- `TLSX_IMAGE` (`<registry>/tlsx`)
- `TLSX_VERBOSE` (`false`)
- `USERMANAGEMENT_DB` (`jwt`)
- `USERMANAGEMENT_DB_USER` (`jwtuser`)
- `USERMANAGEMENT_DEBUG_ENABLED` (`false`)
- `USER_MANAGEMENT_IMAGE` (`<registry>/user-management:<release>`)

Now login to the Platina registry,

```console
$ docker login <registry>
```

Finally,

```console
$ docker compose up -d
```

---

*&copy; 2023 Platina Systems, Inc. All rights reserved.
Use of this source code is governed by this [LICENSE](./LICENSE).*
