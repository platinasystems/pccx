pccx_show() {
	: ${1:?incomplete}
	eval pccx_show_$@
}

pccx_show_files() {
	cat <<-EOF
		$PCCX
		$PCCX_ETC
		$PCCX_LIBEXEC
		$PCCX_LOG
		$PCCX_SHARE
		$PCCX_VAR
	EOF
}
