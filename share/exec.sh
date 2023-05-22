pccx_exec_log=/var/log/${0##*/}.log
pccx_exec_err_log=/var/log/${0##*/}-err.log
pccx_exec_java_debug="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=$PORT_DEBUG"

pccx_exec() {
	pccx_exec_debug=DEBUG_ENABLED_${1:?unspecified service}
	pccx_exec_program=${2:?unspecifed program}
	shift 2
	if test $pccx_exec_program = java; then
		if eval \${${pccx_exec_debug}:-false}; then
			exec >$pccx_exec_log 2>&1 \
				java $JAVA_OPTS $pccx_exec_java_debug $*
		else
			exec >$pccx_exec_log 2>&1 java $JAVA_OPTS $*
		fi
	elif eval \${${pccx_exec_debug}:-false}; then
		dlv --listen=:$PORT_DEBUG --headless=true --api-version=2 \
			-r stderr:$pccx_exec_err_log \
			-r stdout:$pccx_exec_log \
			exec $pccx_exec_program -- $*
	else
		exec >$pccx_exec_log 2>&1 $pccx_exec_program $*
	fi
}
