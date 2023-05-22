pccx_cert() {
	: ${1:?incomplete}
	eval pccx_cert_$@
}

pccx_cert_key_usage="critical, cRLSign, digitalSignature, keyCertSign"

pccx_cert_create() {
	: ${1:?missing container cert file name}
	: ${2:?missing container key file name}
	pccx_cert_subj="/C=$pccx_cert_country"
	pccx_cert_subj="$pccx_cert_subj/ST=$pccx_cert_state_or_province"
	pccx_cert_subj="$pccx_cert_subj/L=$pccx_cert_locality"
	pccx_cert_subj="$pccx_cert_subj/O=$pccx_cert_organization"
	pccx_cert_subj="$pccx_cert_subj/CN=$pccx_cert_common_name"
	pccx_cert_subj="$pccx_cert_subj/emailAddress=$pccx_cert_email"
	openssl req -x509 -out $1 -keyout $2 -sha512 -nodes \
		-newkey rsa:4096 -days 3650 -set_serial 1 \
		-subj "$pccx_cert_subj" \
		-addext "subjectAltName = DNS:$pccx_cert_fqdn" \
		-addext "keyUsage = $pccx_cert_key_usage"
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
	: ${1:?missing container cert file name}
	: ${2:?missing container key file name}
	db_get pccx/cert_algorithm || pccx error
	pccx_cert_algorithm=$RET
	db_get pccx/cert_common_name || pccx error
	pccx_cert_common_name=$RET
	db_get pccx/cert_email || pccx error
	pccx_cert_email=$RET
	db_get pccx/cert_fqdn || pccx error
	pccx_cert_fqdn=$RET
	db_get pccx/cert_organization || pccx error
	pccx_cert_organization=$RET
	db_get pccx/cert_locality || pccx error
	pccx_cert_locality=$RET
	db_get pccx/cert_state_or_province || pccx error
	pccx_cert_state_or_province=$RET
	db_get pccx/cert_country || pccx error
	pccx_cert_country=$RET
	pccx_cert_create $1 $2
}

pccx_cert_prompt() {
	: ${1:?missing container cert file name}
	: ${2:?missing container key file name}
	pccx prompt pccx_cert_algorithm \
		'{ed25519, ecdsa256, ecdsa384, ecdsa512, rsa256, rsa384, rsa512} (default ed25519)'
	: ${pccx_cert_algorithm:=ed25519}
	pccx prompt pccx_cert_common_name
	: ${pccx_cert_common_name:=nothing.no.where}
	pccx prompt pccx_cert_email
	: ${pccx_cert_email:=no.one@no.where}
	_fqdn=$(hostname -f)
	pccx prompt pccx_cert_fqdn \
		'[host fully qualified domain name]' "(default ${_fqdn})"
	: ${pccx_cert_fqdn:=${_fqdn}}
	pccx prompt pccx_cert_organization
	: ${pccx_cert_organization:=unaffiliated}
	pccx prompt pccx_cert_locality
	: ${pccx_cert_locality:="San Francisco"}
	pccx prompt pccx_cert_state_or_province
	: ${pccx_cert_state_or_province:=California}
	pccx prompt pccx_cert_country
	: ${pccx_cert_country:=US}
	pccx_cert_create $1 $2
}
