pccx_trace() {
	eval \$\{TRACE_ENABLED_$1:-false\} && set -x || true
}
