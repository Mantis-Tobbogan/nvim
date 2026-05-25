# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export EDITOR=nvim
export VISUAL=nvim

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

# opencode
export PATH=/home/dhanunjay/.opencode/bin:$PATH

# Git function
g() {
  if [ "$1" = "st" ]; then
    git status
  else
    git "$@"
  fi
}

# Source alias
alias so=source
alias ssh='kitten ssh'

alias pyclean='find . -type f -name "*.pyc" -delete -o -type d -name "__pycache__" -exec rm -rf {} +'

# Eza (modern ls)
alias ls='eza --icons'
alias ll='eza --icons -l --git'
alias lt='eza --icons --tree --level=2'
alias la='eza --icons -la --git'

# Mise
eval "$(/home/dhanunjay/.local/bin/mise activate bash)"

# Starship
eval "$(starship init bash)"

# Zoxide
eval "$(zoxide init bash)"

# Fzf
source /usr/share/fzf/shell/key-bindings.bash

# Dotfiles bare repo alias
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
export PATH="$HOME/.local/share/yabridge:$PATH"
