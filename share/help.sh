pccx_help() {
	cat <<-EOF
	Usage: pccx <command> [<args>]...

	Commands:
	  compose       Run \`docker-compose\` command with pccx files.
	  configure     Configure pccx files.
	  install	Install to </usr/local> or, if not super user, 
	  		<\$HOME/.local>.
	  show files    Print pccx file paths.
	EOF
}
