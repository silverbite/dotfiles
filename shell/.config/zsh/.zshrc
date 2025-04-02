#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

[[ -a "$HOME/.config/shell/functions.sh" ]] && source "$HOME/.config/shell/functions.sh"
[[ -a "$HOME/.config/shell/env.sh" ]] && source "$HOME/.config/shell/env.sh"
[[ -a "$HOME/.config/shell/aliases.sh" ]] && source "$HOME/.config/shell/aliases.sh"
[[ -a "$HOME/.config/shell/prompt.sh" ]] && source "$HOME/.config/shell/prompt.sh"

