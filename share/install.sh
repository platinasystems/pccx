pccx_install() {
	if test $UID -eq 0; then
		for d in /usr/local/libexec/pccx \
			/usr/local/share/pccx \
			/usr/local/sbin
		do test -d $d || install -d $d; done
		install -C $PCCX_LIBEXEC/* /usr/local/libexec/pccx
		install -C $PCCX_SHARE/* /usr/local/share/pccx
		install -C $PCCX /usr/local/sbin
	else
		for d in $HOME/.local/libexec/pccx \
			$XDG_DATA_HOME/pccx  \
			$HOME/.local/bin
		do test -d $d || install -d $d; done
		install -C $PCCX_LIBEXEC/* $HOME/.local/libexec/pccx
		install -C $PCCX_SHARE/* $XDG_DATA_HOME/pccx
		install -C $PCCX $HOME/.local/bin
	fi
}
