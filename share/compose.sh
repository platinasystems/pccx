pccx_compose() {
	docker compose -p pccx \
		--project-directory $PWD \
		--file $PCCX_SHARE/docker-compose.yml \
		--env-file $PCCX_ETC/docker-compose.env \
		$@
}
