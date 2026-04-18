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

# LS Colors
eval "$(dircolors -b ~/.dircolors)"

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

# Git alias
alias g=git

# Source alias
alias so=source

alias pyclean='find . -type f -name "*.pyc" -delete -o -type d -name "__pycache__" -exec rm -rf {} +'
# LS alias with colors
alias ls='ls --color=auto'

# Mise
eval "$(/home/dhanunjay/.local/bin/mise activate bash)"

# Starship
eval "$(starship init bash)"

# Zoxide
eval "$(zoxide init bash)"

# Dotfiles bare repo alias
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
