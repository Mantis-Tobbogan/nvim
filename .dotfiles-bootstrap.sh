#!/bin/bash
set -e

DOTFILES_REMOTE="git@github.com:mantis-tobbogan/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_ALIAS="/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME"

echo "Setting up dotfiles..."

if [ ! -d "$DOTFILES_DIR" ]; then
    git clone --bare "$DOTFILES_REMOTE" "$DOTFILES_DIR"
fi

alias dotfiles="$DOTFILES_ALIAS"

mkdir -p ~/.dotfiles-backup
$DOTFILES_ALIAS checkout 2>&1 | egrep "\s+\." | awk '{print $1}' | while read -r f; do
    mkdir -p ~/.dotfiles-backup/$(dirname "$f")
    mv "$f" ~/.dotfiles-backup/"$f"
done

$DOTFILES_ALIAS checkout
$DOTFILES_ALIAS config --local status.showUntrackedFiles no

for rc in ~/.bashrc ~/.zshrc; do
    if [ -f "$rc" ] && ! grep -q "alias dotfiles=" "$rc"; then
        echo "" >> "$rc"
        echo "# Dotfiles bare repo alias" >> "$rc"
        echo "alias dotfiles='/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> "$rc"
    fi
done

echo "Dotfiles setup complete! Run: source ~/.bashrc"
