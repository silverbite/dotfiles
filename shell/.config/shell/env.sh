# Zsh history related
export HISTSIZE=100000
export SAVEHIST=100000
setopt HIST_IGNORE_DUPS

# Default path
export PATH="$PATH:/usr/sbin:/sbin:/opt/local/bin:/opt/local/sbin"

# Manually set language environment
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# homebrew on linux
[[ -d /home/linuxbrew/.linuxbrew/bin/ ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Include local user bin dir
[[ -d "$HOME/.local/bin" ]] && export PATH="$PATH:$HOME/.local/bin"

# Setup fzf
type -p fzf >/dev/null && source <(fzf --zsh)

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

# Python related
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PYTHONIOENCODING='UTF-8'
export ANSIBLE_NOCOWS=1
export BAT_THEME="TwoDark"

# Rust support
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$PATH:$HOME/.cargo/bin"
[[ -s "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Dircolors
[[ $commands[dircolors] ]] && \
eval "$(dircolors -p | \
    sed 's/ 4[0-9];/ 01;/; s/;4[0-9];/;01;/g; s/;4[0-9] /;01 /' | \
    dircolors /dev/stdin)"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"

# direnv
[[ $commands[direnv] ]] && eval "$(direnv hook zsh)"

# Dont clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Gcloud CLI
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# SOPS Key
export SOPS_AGE_KEY_FILE=$HOME/.local/vault/age.key
