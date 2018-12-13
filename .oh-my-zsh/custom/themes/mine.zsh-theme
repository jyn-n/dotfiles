local ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})ᐅ"

function virtual_env_info(){
	[[ -n $VIRTUAL_ENV_PATH ]] || return
	[[ `pwd` == ${VIRTUAL_ENV_PATH}* ]] && local venv_status="%{$fg[green]%}" || local venv_status="%{$fg_bold[red]%}"
	echo " ${venv_status}(`basename $VIRTUAL_ENV_PATH`)%{$reset_color%}"
}

PROMPT='%{$fg[cyan]%}%~%{$reset_color%}${GIT_PROMPT_INFO}$(virtual_env_info)$(git_prompt_info) %{$reset_color%}${ret_status}%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow] ✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""