
function activate_virtualenv() {
	[[ $# -ne 1 ]] && echo "usage: $0 <directory>" && return
	[[ -d $1 ]] || echo "$1 is not a directory"
	[[ -d $1 ]] || return

	#beware not to choose a directory that is not a virtualenv dir!

	VIRTUAL_ENV=$1
	VIRTUAL_ENV_PATH=`pwd`
	_OLDPATH=$PATH
	PATH=$VIRTUAL_ENV/bin:$PATH

	pip completion --zsh > $1/.zsh_pip_completions
	source $1/.zsh_pip_completions

	function deactivate() {
		rm $VIRTUAL_ENV_PATH/$VIRTUAL_ENV/.zsh_pip_completions
		unset VIRTUAL_ENV
		unset VIRTUAL_ENV_PATH
		PATH=$_OLDPATH
		unset _OLDPATH
		unset -f deactivate
	}
}

compdef _dirs activate_virtualenv

