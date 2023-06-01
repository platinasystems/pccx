pccx_show() {
	: ${1:?incomplete}
	eval pccx_show_$@
}

pccx_show_paths() {
	cat <<-EOF
		bin	$PCCX
		etc	$PCCX_ETC
		libexec	$PCCX_LIBEXEC
		log	$PCCX_LOG
		share	$PCCX_SHARE
		var	$PCCX_VAR
		key	$PCCX_KEY
	EOF
}
