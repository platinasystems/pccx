pccx_merge() {
	pccx_merge_combiner=${1:?unspecified combiner}
	pccx_merge_image=${2:?unspecified image}
	pccx_merge_config=${3:?unspecified config}
	pccx_merge_output=${4:?unspecified output}
	test ! -r $pccx_merge_output || return 0
	pccx_merge_input=${pccx_merge_output}~
	cp $pccx_merge_config $pccx_merge_output
	sed '/^\s\+profiles: docker$/d' $pccx_merge_image \
		> $pccx_merge_input
	eval $pccx_merge_combiner --log-path /var/log/merge.log \
		--default-conf $pccx_merge_input \
		--current-conf $pccx_merge_output \
		--output $pccx_merge_output
	if test $? -ne 0; then
		echo ${0##*/}: failed to merge $pccx_merge_output >&2
		return 1
	fi
}
