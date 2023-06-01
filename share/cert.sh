pccx_cert() {
	: ${1:?incomplete}
	eval pccx_cert_$@
}

pccx_cert_key_usage="critical, cRLSign, digitalSignature, keyCertSign"

pccx_cert_create() {
	pccx_cert_subj="/C=$pccx_cert_C"
	pccx_cert_subj="$pccx_cert_subj/ST=$pccx_cert_ST"
	pccx_cert_subj="$pccx_cert_subj/L=$pccx_cert_L"
	pccx_cert_subj="$pccx_cert_subj/O=$pccx_cert_O"
	pccx_cert_subj="$pccx_cert_subj/OU=$pccx_cert_OU"
	pccx_cert_subj="$pccx_cert_subj/CN=$pccx_cert_CN"
	pccx_cert_subj="$pccx_cert_subj/emailAddress=$pccx_cert_email"
	openssl req -new -x509 \
		-key $PCCX_KEY -keyform pem \
		-out $PCCX_ETC/cert.pem \
		-days 3650 \
		-set_serial 1 \
		-subj "$pccx_cert_subj" \
		-addext "subjectAltName=DNS:$pccx_cert_fqdn" \
		-addext "keyUsage=$pccx_cert_key_usage"
	#: ${TLSX_IMAGE:=platinadownload.auctacognitio.com/tlsx}
	#docker run --rm --user ${UID:-$(id -u)}:${GID:-$(id -g)} \
	#	--mount type=bind,source=${1%/*},target=/var/run/ko \
	#	$TLSX_IMAGE --state=/var/run/ko create-cert \
	#		-alg "$pccx_cert_algorithm" \
	#		-country "$pccx_cert_country" \
	#		-dns "$pccx_cert_fqdn" \
	#		-locality "$pccx_cert_locality" \
	#		-name "$pccx_cert_common_name" \
	#		-organization "$pccx_cert_organization" \
	#		-province "$pccx_cert_state_or_province"
}

pccx_cert_debconf() {
	db_get pccx/cert_common_name || pccx error
	pccx_cert_CN=$RET
	db_get pccx/cert_email || pccx error
	pccx_cert_email=$RET
	db_get pccx/cert_organization || pccx error
	pccx_cert_O=$RET
	db_get pccx/cert_organization_unit || pccx error
	pccx_cert_OU=$RET
	db_get pccx/cert_locality || pccx error
	pccx_cert_L=$RET
	db_get pccx/cert_state_or_province || pccx error
	pccx_cert_ST=$RET
	db_get pccx/cert_country || pccx error
	pccx_cert_C=$RET
	db_get pccx/cert_fqdn || pccx error
	pccx_cert_fqdn=$RET
	pccx cert create
}

pccx_cert_prompt() {
	pccx_cert_CN="nothing.no.where"
	pccx_cert_email="no.one@no.where"
	pccx_cert_O="unaffiliated"
	pccx_cert_OU="self"
	pccx_cert_L="San Francisco"
	pccx_cert_ST="California"
	pccx_cert_C="US"
	pccx_cert_fqdn=$(hostname -f)
	pccx prompt "common name (default $pccx_cert_CN)"
	test -z "$pccx_prompt_ret" || pccx_cert_CN=$pccx_prompt_ret
	pccx prompt "email (default $pccx_cert_email)"
	pccx prompt "organization (default $pccx_cert_O)"
	test -z "$pccx_prompt_ret" || pccx_cert_O=$pccx_prompt_ret
	pccx prompt "organization unit (default $pccx_cert_OU)"
	test -z "$pccx_prompt_ret" || pccx_cert_OU=$pccx_prompt_ret
	test -z "$pccx_prompt_ret" || pccx_cert_email=$pccx_prompt_ret
	pccx prompt "locality [city or town] (default $pccx_cert_L)"
	test -z "$pccx_prompt_ret" || pccx_cert_L=$pccx_prompt_ret
	pccx prompt "state or province (default $pccx_cert_ST)"
	test -z "$pccx_prompt_ret" || pccx_cert_ST=$pccx_prompt_ret
	pccx prompt "country (default $pccx_cert_C)"
	test -z "$pccx_prompt_ret" || pccx_cert_C=$pccx_prompt_ret
	pccx prompt "fully qualified domain name (default $pccx_cert_fqdn)"
	test -z "$pccx_prompt_ret" || pccx_cert_fqdn=$pccx_prompt_ret
	pccx cert create
}
