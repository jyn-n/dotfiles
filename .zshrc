ZSH=$HOME/.zsh/

ZSH_CACHE_DIR=$HOME/.cache/zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

autoload -U compaudit compinit

for config_file ($ZSH/lib/*.zsh); do
  source $config_file
done

if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${HOST}-${ZSH_VERSION}"
fi

if ! compaudit &>/dev/null; then
  handle_completion_insecurities
fi

compinit -i -d "${ZSH_COMPDUMP}"

for config_file ($ZSH/custom/*.zsh(N)); do
  source $config_file
done

unset config_file

source "$ZSH/mine.zsh-theme"
