local ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[yellow]%})ᐅ%{$reset_color%}"

function user_info(){
	[[ $(whoami) = 'cptj' ]] || echo "%{$fg[red]%}$(whoami)%{$reset_color%} "
}

function virtual_env_info(){
	[[ -n $VIRTUAL_ENV_PATH ]] || return
	[[ `pwd` == ${VIRTUAL_ENV_PATH}* ]] && local venv_status="%{$fg[green]%}" || local venv_status="%{$fg_bold[red]%}"
	echo " ${venv_status}(`basename $VIRTUAL_ENV_PATH`)%{$reset_color%}"
}

PROMPT='$(user_info)%{$fg[green]%}%~%{$reset_color%}${GIT_PROMPT_INFO}$(virtual_env_info)$(git_prompt_info) %{$reset_color%}
${ret_status} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow] ✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
